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
require "konbata/models/canvas_course"

describe Konbata::CanvasCourse do
  describe "#create" do
    describe "without opts" do
      before do
        @title = "Test Course"
        @canvas_course = Konbata::CanvasCourse.create(@title)
      end

      it "returns a canvas_cc course" do
        assert_kind_of(CanvasCc::CanvasCC::Models::Course, @canvas_course)
      end

      it "gives the canvas_cc course an identifier" do
        refute_nil(@canvas_course.identifier)
      end

      it "gives the canvas_cc course a default course code" do
        assert_equal(@title, @canvas_course.course_code)
      end

      it "gives the canvas_cc course a title" do
        assert_equal(@title, @canvas_course.title)
      end

      it "does not give the canvas_cc course a default view" do
        assert_nil(@canvas_course.default_view)
      end
    end

    describe "with opts" do
      before do
        @title = "Test Course"
        @course_code = "test-course-123"
        @default_view = "modules"
        @canvas_course = Konbata::CanvasCourse.create(
          @title,
          course_code: @course_code,
          default_view: @default_view,
        )
      end

      it "gives the canvas_cc course the course_code in opts" do
        assert_equal(@course_code, @canvas_course.course_code)
      end

      it "gives the canvas_cc course a default view" do
        assert_equal(@default_view, @canvas_course.default_view)
      end
    end
  end
end
