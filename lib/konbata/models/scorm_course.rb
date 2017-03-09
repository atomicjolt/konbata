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

require "zip"
require "konbata/models/canvas_course"
require "konbata/models/scorm_file"
require "konbata/models/scorm_page"

module Konbata
  class ScormCourse
    attr_reader :canvas_course

    MANIFEST_FILENAME = "imsmanifest.xml".freeze

    def initialize(package_path)
      @package_path = package_path
    end

    def canvas_course
      @canvas_course ||= begin
        canvas_course = CanvasCourse.create(_course_title)
        scorm_file = ScormFile.new(@package_path)

        canvas_course.files << scorm_file.canvas_file
        _pdf_files.each { |file| canvas_course.files << file.canvas_file }
        _pdf_pages.each { |page| canvas_course.pages << page.canvas_page }

        canvas_course
      end
    end

    private

    ##
    # Finds the SCORM manifest in the zip package and returns it as a Nokogiri
    # object.
    ##
    def _manifest
      @scorm_manifest ||= begin
        temp_dir = Dir.mktmpdir
        manifest_path = File.join(temp_dir, MANIFEST_FILENAME)

        Zip::File.new(@package_path).entries.detect do |entry|
          entry.name == MANIFEST_FILENAME
        end.extract(manifest_path)

        File.open(manifest_path) { |file| Nokogiri::XML(file) }
      end
    end

    ##
    # Reads the course title from the manifest file.
    ##
    def _course_title
      @title ||= begin
        default_org_id = _manifest.at(:organizations).attr(:default)

        org = _manifest.at("organization[identifier='#{default_org_id}']")
        org.at(:title).text
      end
    end

    ##
    # Iterates through the SCORM package and returns any PDF files.
    ##
    def _scorm_pdfs
      @pdfs ||= begin
        temp_dir = Dir.mktmpdir

        pdf_entries = Zip::File.new(@package_path).entries.select do |entry|
          File.extname(entry.name) == ".pdf"
        end

        pdf_entries.map do |entry|
          extract_to = File.join(temp_dir, File.basename(entry.name))
          entry.extract(extract_to)

          extract_to
        end
      end
    end

    # Creates a ScormFile object for each element in _scorm_pdfs and returns
    # them as an array.
    def _pdf_files
      _scorm_pdfs.map do |pdf|
        ScormFile.new(pdf)
      end
    end

    # Creates a ScormPage object for each element in _scorm_pdfs and returns
    # them as an array.
    def _pdf_pages
      _scorm_pdfs.map do |pdf|
        ScormPage.new(pdf)
      end
    end
  end
end
