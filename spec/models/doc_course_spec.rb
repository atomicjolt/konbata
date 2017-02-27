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

require_relative "../helpers/spec_helper"

describe Konbata do
  before do
    @course_code = "course-code-001"
    volumes = {
      "1" => [
        fixture_path("front.doc"),
      ],
      "2" => [
        fixture_path("glos.doc"),
        fixture_path("u1.doc"),
      ],
    }

    @course = MockDocCourse.new(@course_code, volumes)
  end

  describe "Course" do
    describe "_add_raw_source_files" do
      it "should populate canvas_cc course with files" do
        assert_equal(3, @course.canvas_course.files.size)

        assert_equal(
          File.join(fixture_path("front.doc")),
          @course.canvas_course.files.first.file_location,
        )
      end
    end

    describe "_convert_source_files" do
      it "should add a module for each volume" do
        assert_equal(2, @course.canvas_course.canvas_modules.size)
      end
      it "should sort the modules by volume number" do
        assert_equal("Volume 1", @course.canvas_course.canvas_modules[0].title)
        assert_equal("Volume 2", @course.canvas_course.canvas_modules[1].title)
      end
    end
  end
end
