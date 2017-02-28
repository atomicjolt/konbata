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
require "konbata/models/scorm_course"

describe Konbata do
  describe "ScormCourse" do
    describe "#_create_canvas_course" do
      before do
        @scorm_course = Konbata::ScormCourse.new("sources/Test_Package.zip")
      end

      it "should return a canvas_course" do
        refute_nil(@scorm_course.canvas_course)
      end

      it "should add the SCORM file to the canvas_course" do
        assert_equal(1, @scorm_course.canvas_course.files.size)
      end
    end
  end
end
