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
        @scorm_zip = fixture_path("scorm_with_no_pdfs.zip")
        @scorm_course = Konbata::ScormCourse.new(@scorm_zip)
      end

      it "should return a canvas_course" do
        refute_nil(@scorm_course.canvas_course)
      end

      it "should add the SCORM file to the canvas_course" do
        scorm_file = @scorm_course.canvas_course.files.detect do |file|
          file.file_location = @scorm_zip
        end

        assert(scorm_file)
      end
    end

    describe "#_scorm_pdfs" do
      it "should return canvas_cc files" do
        scorm_zip = fixture_path("scorm_with_1_pdf.zip")
        scorm_course = Konbata::ScormCourse.new(scorm_zip)

        pdf_file = scorm_course.canvas_course.files.detect do |file|
          File.extname(file.file_location) =~ /\.pdf/i
        end

        assert_kind_of(CanvasCc::CanvasCC::Models::CanvasFile, pdf_file)
      end

      it "should return no files if there are no PDFs" do
        scorm_zip = fixture_path("scorm_with_no_pdfs.zip")
        scorm_course = Konbata::ScormCourse.new(scorm_zip)

        pdf_files = scorm_course.canvas_course.files.select do |file|
          File.extname(file.file_location) =~ /\.pdf/i
        end

        assert_empty(pdf_files)
      end

      it "should return a single file if there is 1 PDF" do
        scorm_zip = fixture_path("scorm_with_1_pdf.zip")
        scorm_course = Konbata::ScormCourse.new(scorm_zip)

        pdf_files = scorm_course.canvas_course.files.select do |file|
          File.extname(file.file_location) =~ /\.pdf/i
        end

        assert_equal(1, pdf_files.size)
      end

      it "should return multiple files if there are multiple PDFs" do
        scorm_zip = fixture_path("scorm_with_3_pdfs.zip")
        scorm_course = Konbata::ScormCourse.new(scorm_zip)

        pdf_files = scorm_course.canvas_course.files.select do |file|
          File.extname(file.file_location) =~ /\.pdf/i
        end

        assert_equal(3, pdf_files.size)
      end
    end
  end
end
