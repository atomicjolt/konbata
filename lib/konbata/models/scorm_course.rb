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

require "konbata/models/canvas_course"
require "konbata/models/scorm_file"

module Konbata
  class ScormCourse
    attr_reader :canvas_course

    def initialize(package_path)
      @package_path = package_path
      # TODO: Consider using <title> node for course name.
      @course_title = File.basename(package_path, ".zip")
      @canvas_course = _create_canvas_course
    end

    private

    def _create_canvas_course
      canvas_course = CanvasCourse.create(@course_title)
      scorm_file = ScormFile.new(@package_path)

      canvas_course.files << scorm_file.canvas_file

      canvas_course
    end
  end
end
