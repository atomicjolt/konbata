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
require "konbata/models/canvas_module"
require "konbata/models/canvas_module_item"
require "konbata/models/scorm_package"
require "konbata/models/scorm_file"
require "konbata/models/scorm_page"

module Konbata
  class ScormCourse
    def initialize(package_path)
      @package = ScormPackage.new(package_path)
    end

    def cleanup
      @package.cleanup
    end

    private

    ##
    # Creates a canvas_cc course for the SCORM package.
    ##
    def _create_canvas_course(default_view)
      canvas_course = CanvasCourse.create(
        # @package.course_title,
        File.basename(@package.filepath, ".zip"),
        course_code: @package.course_code,
        default_view: default_view,
      )

      scorm_file = ScormFile.new(@package.filepath)
      canvas_course.files << scorm_file.canvas_file

      _pdfs_to_files.each { |file| canvas_course.files << file.canvas_file }
      _images_to_files.each { |file| canvas_course.files << file.canvas_file }

      canvas_course
    end

    ##
    # Creates a ScormFile object for each element in @package.pdfs and returns
    # them as an array.
    ##
    def _pdfs_to_files
      @package.pdfs.map do |extracted_to, file_name|
        ScormFile.new(extracted_to, file_name)
      end
    end

    ##
    # Creates a ScormFile object for each element in @package.resource_images
    # and returns them as an array.
    ##
    def _images_to_files
      @package.resource_images.map do |image|
        ScormFile.new(image, File.join("images", File.basename(image)))
      end
    end
  end
end
