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
  class PDFCourse
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
    # Extracts the list of files from the SCORM package zip and returns a nested
    # list of the file name and extracted locations.
    ##
    def _extract_files(files)
      zip = Zip::File.new(@zip_path)

      files.map do |file|
        FileUtils.mkdir_p(File.join(@temp_dir, File.dirname(file)))
        extract_to = File.join(@temp_dir, file)

        unless File.exist?(extract_to)
          zip.find_entry(file).extract(extract_to)
        end

        [extract_to, file]
      end
    end
  end
end
