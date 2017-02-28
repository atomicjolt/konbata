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
  describe "SourceFile" do
    describe "self.create" do
      before do
        @title = "Test Module Item"
        @identifierref = Konbata.create_random_hex
        @module_item = Konbata::CanvasModuleItem.create(@title, @identifierref)
      end

      it "should return a canvas_cc module item" do
        assert(@module_item.is_a?(CanvasCc::CanvasCC::Models::ModuleItem))
      end

      it "should give the module item a title" do
        assert_equal(@title, @module_item.title)
      end

      it "should give the module item an identifier" do
        refute_nil(@module_item.identifier)
      end

      it "should give the module item a content type of 'WikiPage'" do
        assert_equal("WikiPage", @module_item.content_type)
      end

      it "should give the module item an identifierref" do
        assert_equal(@identifierref, @module_item.identifierref)
      end

      it "should give the module item a workflow state of 'acvive'" do
        assert_equal("active", @module_item.workflow_state)
      end
    end
  end
end
