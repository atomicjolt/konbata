require "canvas_cc"
require "pandarus"
require "rest-client"

module Konbata
  class UploadCourse
    attr_reader :canvas_course

    def initialize(course_resource)
      @course_resource = course_resource
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
    def self.from_metadata(metadata)
      course_title = metadata[:title]
      # TODO: Actually use the course_code somewhere
      # course_code = metadata[:course_code]
      course_resource = client.create_new_course(
        Konbata.configuration.account_id,
        course: {
          name: course_title,
        },
      )
      UploadCourse.new(course_resource)
    end
    
    ##
    # Create a migration for the course
    # and upload the imscc file to be imported into the course
    ##
    def upload_content(filename)
      client = UploadCourse.client
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
      puts "Done uploading: #{name}"
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
  end
end
