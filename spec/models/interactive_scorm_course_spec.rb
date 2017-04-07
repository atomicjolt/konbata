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
require "konbata/models/interactive_scorm_course"

describe Konbata::InteractiveScormCourse do
  describe "#canvas_course" do
    before do
      scorm_zip = fixture_path("scorm_with_no_pdfs.zip")
      @scorm_course = Konbata::InteractiveScormCourse.new(scorm_zip)
    end

    it "sets default view to 'assignments'" do
      assert_equal("assignments", @scorm_course.canvas_course.default_view)
    end
  end
end
