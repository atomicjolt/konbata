# Copyright (C) 2017  Atomic Jolt
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require "canvas_cc"
require "pandarus"
require "rest-client"
require "zip"

module Konbata
  class UploadCourse
    attr_reader :canvas_course

    POINTS_POSSIBLE = 100

    def initialize(course_resource, type)
      @course_resource = course_resource
      @type = type
    end

    ##
    # Given a filename to a imscc file, extract the necessary metadata
    # for the course
    ##
    def self.metadata_from_file(filename)
      Zip::File.open(filename) do |file|
        settings = "course_settings/course_settings.xml"
        config = file.find_entry(settings).get_input_stream.read
        doc = Nokogiri::XML(config)
        {
          title: doc.at("title").text,
          course_code: doc.at("course_code").text,
        }
      end
    end

    ##
    # Create a new pandarus instance to communicate with the canvas server
    ##
    def self.client
      @client ||= Pandarus::Client.new(
        prefix: Konbata.configuration.canvas_url,
        token: Konbata.configuration.canvas_token,
      )
    end

    ##
    # Find or Create a new CanvasCourse instance from the given metadata
    ##
    def self.from_metadata(metadata, type)
      course_title = metadata[:title]
      # TODO: Actually use the course_code somewhere
      # course_code = metadata[:course_code]
      course_resource = client.create_new_course(
        Konbata.configuration.account_id,
        course: {
          name: course_title,
        },
      )
      Konbata::UploadCourse.new(course_resource, type)
    end

    ##
    # Uploads a scorm package to scorm manager specified in konbata.yml
    # config file
    ##
    def upload_scorm_package(scorm_zip, course_id)
      File.open(scorm_zip, "rb") do |file|
        RestClient.post(
          "#{Konbata.configuration.scorm_url}/api/scorm_courses",
          {
            oauth_consumer_key: "scorm-player",
            lms_course_id: course_id,
            file: file,
          },
          SharedAuthorization: Konbata.configuration.scorm_shared_auth,
        ) do |resp|
          JSON.parse(resp.body)["response"]
        end
      end
    end

    ##
    # Create a migration for the course
    # and upload the imscc file to be imported into the course
    ##
    def upload_content(filename, source_for_imscc)
      client = Konbata::UploadCourse.client
      name = File.basename(filename)
      # Create a migration for the course and get S3 upload authorization
      migration = client.
        create_content_migration_courses(
          @course_resource.id,
          :canvas_cartridge_importer,
          pre_attachment: { name: name },
        )

      puts "Uploading: #{name}"
      upload_to_s3(migration, filename)
      change_tabs_visibility
      puts "Done uploading: #{name}"

      if File.exist?(source_for_imscc)
        puts "Creating Scorm: #{name}"
        response = upload_scorm_package(source_for_imscc, @course_resource.id)

        if @type == :interactive
          create_scorm_assignment_external(response, @course_resource.id)
        end

        puts "Done creating scorm: #{name}"
      end
    end

    def upload_to_s3(migration, filename)
      File.open(filename, "rb") do |file|
        # Attach the file to the S3 auth
        pre_attachment = migration.pre_attachment
        upload_url = pre_attachment["upload_url"]
        upload_params = pre_attachment["upload_params"]
        upload_params[:file] = file

        # Post to S3
        RestClient::Request.execute(
          method: :post,
          url: upload_url,
          payload: upload_params,
          timeout: Konbata.configuration.request_timeout,
        ) do |response|
          # Post to Canvas
          RestClient.post(
            response.headers[:location],
            nil,
            Authorization: "Bearer #{Konbata.configuration.canvas_token}",
          )
        end
      end
    end

    ##
    # Requests all of the tabs available for a course. Sets hidden to `false`
    # for any tab in the label whitelist; sets hidden to `true` for all others.
    # `whitelisted_labels` should be an array of strings or regexps.
    ##
    def change_tabs_visibility(whitelisted_labels = nil)
      whitelisted_labels ||= _default_whitelisted_labels
      whitelisted_labels.map! { |label| Regexp.new(label) }

      tab_url_base = Konbata.configuration.canvas_url +
        "/v1/courses/#{@course_resource.id}/tabs"

      tabs = get_tabs(tab_url_base)

      tabs.each do |tab|
        # Settings and Home tabs can't be changed.
        next if tab["id"] == "home" || tab["id"] == "settings"

        visible = whitelisted_labels.any? { |label| tab["label"] =~ label }

        change_tab_visibility(tab, visible, tab_url_base)
      end
    end

    ##
    # Gets the tabs from the given Canvas URL.
    ##
    def get_tabs(tab_url_base)
      RestClient.get(
        tab_url_base,
        Authorization: "Bearer #{Konbata.configuration.canvas_token}",
      ) do |response|
        JSON.parse(response.body)
      end
    end

    ##
    # Issues a PUT request to Canvas using the given URL and sets the given
    # tabs hidden attribute to true or false.
    ##
    def change_tab_visibility(tab, visible, tab_url_base)
      RestClient.put(
        tab_url_base + "/#{tab['id']}",
        {
          hidden: !visible,
        },
        Authorization: "Bearer #{Konbata.configuration.canvas_token}",
      )
    rescue RestClient::BadRequest => e
      puts "WARNING: Failed to update tab #{tab['label']} for course " \
      "#{@course_resource.id}. Error: #{e}"
    end

    ##
    # Assembles the launch url with the course_id
    ##
    def scorm_launch_url(package_id)
      "#{Konbata.configuration.scorm_launch_url}?course_id=#{package_id}"
    end

    ##
    # Creates a scorm assignment using the Canvas api
    ##
    def create_scorm_assignment_external(upload_response, course_id)
      url = scorm_launch_url(upload_response["package_id"])

      payload = {
        assignment__submission_types__: ["external_tool"],
        assignment__integration_id__: upload_response["package_id"],
        assignment__integration_data__: {
          provider: "atomic-scorm",
        },
        assignment__external_tool_tag_attributes__: {
          url: url,
        },
        assignment__points_possible__: POINTS_POSSIBLE,
      }

      Konbata::UploadCourse.client.create_assignment(
        course_id,
        upload_response["title"],
        payload,
      )
    end

    private

    ##
    # Returns the default whitelisted labels based on course type.
    ##
    def _default_whitelisted_labels
      labels = [/home/i, /scorm/i]

      if @type == :interactive
        labels << /assignments/i
      elsif @type == :non_interactive
        labels << /modules/i
      end

      labels
    end
  end
end
