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

describe Konbata::ScormPackage do
  before do
    @scorm_package = Konbata::ScormPackage.new(
      fixture_path("non_interactive_scorm.zip"),
    )
  end

  describe "#course_title" do
    it "returns the course title from the manifest" do
      assert_equal("Sample Course", @scorm_package.course_title)
    end
  end

  describe "#course_code" do
    it "returns the course code from the manifest" do
      assert_equal("Sample_Course", @scorm_package.course_code)
    end
  end

  describe "#pdfs" do
    it "returns a nested array of the PDF files in the SCORM package" do
      assert_kind_of(Array, @scorm_package.pdfs)
      assert_kind_of(Array, @scorm_package.pdfs.first)
    end

    it "returns the correct number of PDF files" do
      assert_equal(2, @scorm_package.pdfs.size)
    end

    it "returns the name of the PDF file" do
      assert_equal("Volume1/volume1.pdf", @scorm_package.pdfs.first[1])
    end
  end

  describe "#resource_images" do
    it "returns an array of the image files in the SCORM package" do
      assert_kind_of(Array, @scorm_package.resource_images)
    end

    it "returns the correct number of images" do
      assert_equal(4, @scorm_package.resource_images.size)
    end
  end

  describe "#items" do
    it "returns a hash of all the items in the manifest" do
      assert_kind_of(Hash, @scorm_package.items)
    end

    it "adds a Struct to the hash for each item" do
      assert_kind_of(Struct, @scorm_package.items.first[1])
    end

    it "gives the item Structs a title" do
      assert_equal("Orientation", @scorm_package.items.first[1].title)
    end

    it "gives the item Structs a directory" do
      assert(@scorm_package.items.first[1].directory)
    end

    it "gives the item Structs a primary file" do
      assert_equal(
        "Orientation/orientation.html",
        @scorm_package.items.first[1].primary_file,
      )
    end

    it "gives the item Structs a list of files" do
      assert_equal(
        ["Orientation/orientation.html"],
        @scorm_package.items.first[1].files,
      )
    end
  end

  describe "#_default_organization" do
    before do
      @package_without_default_org = Konbata::ScormPackage.new(
        fixture_path("non_interactive_scorm_no_default_organization.zip"),
      )
    end

    it "uses the first organization in the manifest if there is no default" do
      assert_equal("Sample Course", @package_without_default_org.course_title)
    end
  end
end
