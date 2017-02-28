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
  describe "Module" do
    describe "self.create" do
      before do
        @volume = "3"
        @module = Konbata::CanvasModule.create(@volume)
      end

      it "should return a canvas_cc module" do
        assert(@module.is_a?(CanvasCc::CanvasCC::Models::CanvasModule))
      end

      it "should give the module an identifier" do
        refute_nil(@module.identifier)
      end

      it "should give the module a title" do
        assert_equal("Volume 3", @module.title)
      end

      it "should give the module a workflow state of 'active'" do
        assert_equal("active", @module.workflow_state)
      end
    end
  end
end
