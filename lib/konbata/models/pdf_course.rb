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
        _add_file_to_module(canvas_module, file)
      end

      canvas_module.module_items.sort_by!(&:title)
      canvas_course.canvas_modules << canvas_module

      canvas_course
    end

    ##
    # Creates a Canvas module item for the given file and adds it to the
    # given Canvas module.
    ##
    def _add_file_to_module(canvas_module, file)
      module_item = CanvasModuleItem.create(
        File.basename(file.canvas_file.file_path),
        file.canvas_file.identifier,
        "Attachment",
      )

      canvas_module.module_items << module_item
    end

    ##
    # Creates a ScormFile object for each PDF in the zip file and returns
    # them as an array.
    ##
    def _pdfs_to_files
      pdfs = Konbata::ZipUtils.pdfs(@zip_path)
      extracted_pdfs = Konbata::ZipUtils.extract_files(
        @zip_path,
        pdfs,
        @temp_dir,
      )

      extracted_pdfs.map do |extracted_to, file_name|
        Konbata::ScormFile.new(extracted_to, file_name)
      end
    end
  end
end
