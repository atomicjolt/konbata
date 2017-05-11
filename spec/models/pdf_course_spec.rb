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
require "konbata/models/pdf_course"

describe Konbata::PDFCourse do
  before do
    @zip_path = fixture_path("zipped_pdfs.zip")
    @pdf_course = Konbata::PDFCourse.new(@zip_path)
  end

  describe "#canvas_course" do
    before do
      @canvas_course = @pdf_course.canvas_course
      @canvas_module = @canvas_course.canvas_modules.first
    end

    it "returns a canvas_cc course" do
      assert_kind_of(CanvasCc::CanvasCC::Models::Course, @canvas_course)
    end

    it "gives the course the correct title" do
      expected_title = File.basename(@zip_path, ".zip")
      assert_equal(expected_title, @canvas_course.title)
    end

    it "gives the course the correct default view" do
      assert_equal("modules", @canvas_course.default_view)
    end

    it "adds a canvas_cc module to the course" do
      assert_equal(1, @canvas_course.canvas_modules.count)
      assert_kind_of(
        CanvasCc::CanvasCC::Models::CanvasModule,
        @canvas_module,
      )
    end

    it "adds all PDFs to the module" do
      assert_equal(3, @canvas_module.module_items.count)
    end

    it "adds the PDFs as module items with content type of 'Attachment'" do
      assert_equal("Attachment", @canvas_module.module_items.first.content_type)
    end

    it "sorts the PDFs by title" do
      pdfs = @canvas_module.module_items.map(&:title)
      assert_equal(%w{pdf1.pdf pdf2.pdf pdf3.pdf}, pdfs)
    end
  end
end
