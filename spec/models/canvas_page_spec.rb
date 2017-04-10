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
require "konbata/models/canvas_page"

describe Konbata::CanvasPage do
  describe ".create" do
    before do
      @title = "Test Page"
      @body = "<html><p>This is some test HTML.</p></html>"
      @canvas_page = Konbata::CanvasPage.create(@title, @body)
    end

    it "returns a canvas_cc page" do
      assert(@canvas_page.is_a?(CanvasCc::CanvasCC::Models::Page))
    end

    it "gives the page an identifier" do
      assert(@canvas_page.identifier)
    end

    it "gives the page a workflow state of active" do
      assert_equal("active", @canvas_page.workflow_state)
    end

    it "gives the page a title" do
      assert_equal(@title, @canvas_page.title)
    end

    it "gives the page a body" do
      assert_equal(@body, @canvas_page.body)
    end
  end
end
