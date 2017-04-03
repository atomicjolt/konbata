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
require "konbata/models/scorm_file"

describe Konbata do
  describe "ScormFile" do
    before do
      @local_file_path = "package/module/file.pdf"
      @canvas_file_path = "module/file.pdf"
      @scorm_file = ScormFile.new(
        @file_path,
        @canvas_file_path,
      )
    end

  describe "#_create_canvas_file" do
    it "returns a canvas_cc file" do
      assert_kind_of(
        CanvasCc::CanvasCC::Models::CanvasFile,
        @scorm_file.canvas_file,
      )
    end

    it "gives the canvas_cc file an identifier" do
      refute_nil(@scorm_file.canvas_file.identifier)
    end

    it "gives the canvas_cc file a file location" do
      assert_equal(@file_path, @scorm_file.canvas_file.file_location)
    end

    it "makes the canvas_cc file visible" do
      refute(@scorm_file.canvas_file.hidden)
    end

    it "gives the canvas_cc file a file path" do
      assert_equal(
        @canvas_file_path,
        @scorm_file.canvas_file.file_path,
      )
    end
  end
end
