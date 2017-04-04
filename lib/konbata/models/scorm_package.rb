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
      @temp_dir = Dir.mktmpdir
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
    # Finds and returns any PDF files in the SCORM package as a nested array of
    # PDF file names and extracted locations.
    ##
    def pdfs
      @pdfs ||= begin
        pdf_entries = Zip::File.new(@filepath).entries.select do |entry|
          File.extname(entry.name) =~ /\.pdf/i
        end

        pdf_entries.map!(&:name)
        _extract_files(pdf_entries)
      end
    end

    ##
    # Finds and returns the extracted location of any resource image files from
    # the SCORM package.
    ##
    def resource_images
      @images ||= begin
        _all_resource_files.select do |file|
          File.extname(file) =~ /\.png|\.jpg|\.jpeg/i
        end
      end
    end

    ##
    # Returns a hash of each <item> in the manifest.
    # Keys are the <item> identifier.
    # Values are a struct including title, directory, primary file and files.
    ##
    def items
      @items ||= begin
        _default_organization.search(:item).each_with_object({}) do |itm, items|
          id = itm.attr(:identifier)
          id_ref = itm.attr(:identifierref)
          title = itm.at(:title).text

          items[id] = Struct.new(:title, :directory, :primary_file, :files).new(
            title,
            @temp_dir,
            _item_primary_file(id_ref),
            _item_files(id_ref),
          )
        end
      end
    end

    ##
    # Removes the @temp_dir.
    ##
    def cleanup
      FileUtils.remove_entry_secure(@temp_dir)
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
      @default_organization = begin
        default_organization_id = _manifest.at(:organizations).attr(:default)
        _manifest.at("organization[identifier='#{default_organization_id}']")
      end
    end

    ##
    # Returns a flat list of all resource files in the SCORM package as strings.
    ##
    def _all_resource_files
      @files ||= begin
        files = items.map do |_, item_data|
          item_data.files
        end.flatten

        files.map { |file| File.join(@temp_dir, file) }
      end
    end

    ##
    # Returns the path to the primary file as given in the manifest at
    # resource[href].
    ##
    def _item_primary_file(id_ref)
      _manifest.at(:resources).at("resource[identifier=#{id_ref}]").attr(:href)
    end

    ##
    # Returns a list of extracted files associated with the resource matching
    # id_ref.
    ##
    def _item_files(id_ref)
      resource = _manifest.at(:resources).at("resource[identifier=#{id_ref}]")
      files = resource.search(:file)

      filepaths = files.map { |file| file.attr(:href) }
      _extract_files(filepaths)

      filepaths
    end

    ##
    # Extracts the list of files from the SCORM package zip and returns a nested
    # list of the file name and extracted locations.
    ##
    def _extract_files(files)
      zip = Zip::File.new(@filepath)

      files.map do |file|
        FileUtils.mkdir_p(File.join(@temp_dir, File.dirname(file)))
        extract_to = File.join(@temp_dir, file)
        zip.find_entry(file).extract(extract_to)

        [file, extract_to]
      end
    end
  end
end
