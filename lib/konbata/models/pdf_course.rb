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

require "konbata/zip_utils"

module Konbata
  class PDFCourse
    DEFAULT_VIEW = "modules".freeze

    def initialize(zip_path)
      @zip_path = zip_path
      @temp_dir = Dir.mktmpdir
      @title = File.basename(@zip_path, ".zip")
    end

    ##
    # Creates and memoizes a canvas_cc course for the SCORM package.
    ##
    def canvas_course
      @canvas_course ||= _create_canvas_course
    end

    ##
    # Removes the @temp_dir.
    ##
    def cleanup
      FileUtils.remove_entry_secure(@temp_dir)
    end

    private

    ##
    # Creates a canvas_cc course for the SCORM package.
    ##
    def _create_canvas_course
      canvas_course = Konbata::CanvasCourse.create(
        @title,
        default_view: DEFAULT_VIEW,
      )

      canvas_module = CanvasModule.create(@title)

      _pdfs_to_files.each do |file|
        canvas_course.files << file.canvas_file

        module_item = CanvasModuleItem.create(
          File.basename(file.canvas_file.file_path),
          file.canvas_file.identifier,
          "Attachment",
        )

        canvas_module.module_items << module_item
      end

      canvas_module.module_items.sort_by!(&:title)
      canvas_course.canvas_modules << canvas_module

      canvas_course
    end

    ##
    # Creates a ScormFile object for each element in @package.pdfs and returns
    # them as an array.
    ##
    def _pdfs_to_files
      _pdfs.map do |extracted_to, file_name|
        Konbata::ScormFile.new(extracted_to, file_name)
      end
    end

    ##
    # Finds and returns any PDF files in the SCORM package as a nested array of
    # PDF file names and extracted locations.
    ##
    def _pdfs
      @pdfs ||= begin
        pdf_entries = Zip::File.new(@zip_path).entries.select do |entry|
          File.extname(entry.name) =~ /\.pdf/i
        end

        pdf_entries.map!(&:name)
        _extract_files(pdf_entries)
      end
    end

    ##
    # Creates a ScormFile object for each PDF in the zip file and returns
    # them as an array.
    ##
    def _pdfs_to_files
      pdfs = ZipUtils.pdfs(@zip_path)
      extracted_pdfs = ZipUtils.extract_files(@zip_path, pdfs, @temp_dir)

      extracted_pdfs.map do |extracted_to, file_name|
        Konbata::ScormFile.new(extracted_to, file_name)
      end
    end
  end
end
