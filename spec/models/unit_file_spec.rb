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
  describe "UnitFile" do
    describe "initialize" do
      before do
        file_path = fixture_path("u1.doc")
        @volume = "3"

        @cover_page_file = MockUnitFile.new(file_path, @volume)
        @canvas_course = CanvasCc::CanvasCC::Models::Course.new
        @canvas_module = Konbata::Module.create(@volume)
        @cover_page_file.convert(@canvas_course, @canvas_module)
      end

      it "should create a title" do
        assert_equal(
          "Unit 1 (Vol. #{@volume})",
          @canvas_module.module_items.first.title,
        )
      end
    end
  end
end
