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
require "konbata/models/scorm_package"

describe Konbata do
  describe "ScormPackage" do
    before do
      @scorm_package = Konbata::ScormPackage.new(
        fixture_path("scorm_with_1_pdf.zip"),
      )
    end

    describe "#course_title" do
      it "should return the course title from the manifest" do
        assert_equal("123 Sample Course", @scorm_package.course_title)
      end
    end

    describe "#course_code" do
      it "should return the course code from the manifest" do
        assert_equal("123_Sample_Course", @scorm_package.course_code)
      end
    end

    describe "#pdfs" do
      it "should return an array of the PDF files in the SCORM package" do
        assert_kind_of(Array, @scorm_package.pdfs)
      end

      it "should return the correct number of PDF files" do
        assert_equal(1, @scorm_package.pdfs.size)
      end
    end
  end
end
