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
require "konbata/models/scorm_package"
require "konbata/models/scorm_file"
require "konbata/models/scorm_page"

module Konbata
  class ScormCourse
    attr_reader :canvas_course

    def initialize(package_path)
      @package = ScormPackage.new(package_path)
    end

    def canvas_course
      @canvas_course ||= begin
        canvas_course = CanvasCourse.create(@package.course_title)
        scorm_file = ScormFile.new(@package.filepath)

        canvas_course.files << scorm_file.canvas_file

        _pdfs_to_files.each { |file| canvas_course.files << file.canvas_file }
        _items_to_pages.each { |page| canvas_course.pages << page.canvas_page }

        canvas_course
      end
    end

    def cleanup
      @package.cleanup
    end

    private

    # Creates a ScormFile object for each element in @package.pdfs and returns
    # them as an array.
    def _pdfs_to_files
      @package.pdfs.map do |pdf|
        ScormFile.new(pdf)
      end
    end

    # Creates a ScormPage object for each element in @package.items and returns
    # them as an array.
    def _items_to_pages
      @package.items.map do |_, item_data|
        ScormPage.new(item_data)
      end
    end
  end
end
