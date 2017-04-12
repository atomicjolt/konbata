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

describe Konbata::ScormCourse do
  describe "#_create_canvas_course" do
    before do
      @scorm_zip = fixture_path("interactive_scorm.zip")
      @scorm_course = Konbata::InteractiveScormCourse.new(@scorm_zip)
    end

    it "returns a Canvas course" do
      refute_nil(@scorm_course.canvas_course)
    end

    it "adds the SCORM file to the Canvas course" do
      scorm_file = @scorm_course.canvas_course.files.detect do |file|
        file.file_location = @scorm_zip
      end

      assert(scorm_file)
    end

    it "adds PDF files to the Canvas course" do
      pdf_files = @scorm_course.canvas_course.files.select do |file|
        File.extname(file.file_path) == ".pdf"
      end

      assert_equal(2, pdf_files.count)
    end

    it "adds image files to the Canvas course" do
      image_files = @scorm_course.canvas_course.files.select do |file|
        File.extname(file.file_path) =~ /\.png|\.jpg|\.jpeg/
      end

      assert_equal(3, image_files.count)
    end
  end
end
