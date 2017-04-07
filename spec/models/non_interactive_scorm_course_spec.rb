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
require "konbata/models/non_interactive_scorm_course"

describe Konbata::NonInteractiveScormCourse do
  describe "#canvas_course" do
    before do
      scorm_zip = fixture_path("non_interactive_scorm.zip")
      @scorm_course = Konbata::NonInteractiveScormCourse.new(scorm_zip)
    end

    it "sets default view to 'modules'" do
      assert_equal("modules", @scorm_course.canvas_course.default_view)
    end

    it "adds a page for each item to the canvas_cc course" do
      assert_equal(2, @scorm_course.canvas_course.pages.count)
    end

    it "adds a module to the canvas_cc course" do
      assert_equal(1, @scorm_course.canvas_course.canvas_modules.count)
    end

    it "adds a module item for each page to the canvas_cc module" do
      canvas_module = @scorm_course.canvas_course.canvas_modules.first
      module_items = canvas_module.module_items

      assert_equal(2, module_items.count)
    end
  end
end
