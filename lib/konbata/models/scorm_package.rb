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

module Konbata
  class ScormPackage
    attr_reader :filepath

    MANIFEST_FILENAME = "imsmanifest.xml".freeze

    def initialize(filepath)
      @filepath = filepath
    end

    ##
    # Returns the course title from the manifest file.
    ##
    def course_title
      @course_title ||= _default_organization.at(:title).text
    end

    ##
    # Returns the course code from the manifest file.
    ##
    def course_code
      @course_code ||= _manifest.at(:manifest).attr(:identifier)
    end

    ##
    # Iterates through the SCORM package and returns any PDF files.
    ##
    def pdfs
      @pdfs ||= begin
        Zip::File.new(@filepath).entries.select do |entry|
          File.extname(entry.name) =~ /\.pdf/i
        end
      end
    end

    private

    ##
    # Finds the SCORM manifest in the zip package and returns it as a Nokogiri
    # object.
    ##
    def _manifest
      @manifest ||= begin
        temp_dir = Dir.mktmpdir
        manifest_path = File.join(temp_dir, MANIFEST_FILENAME)

        Zip::File.new(@filepath).entries.detect do |entry|
          entry.name == MANIFEST_FILENAME
        end.extract(manifest_path)

        File.open(manifest_path) { |file| Nokogiri::XML(file) }
      end
    end

    ##
    # Returns the default organization from the manifest as a Nokogiri object.
    ##
    def _default_organization
      default_organization_id = _manifest.at(:organizations).attr(:default)
      _manifest.at("organization[identifier='#{default_organization_id}']")
    end
  end
end
