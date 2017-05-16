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
require "konbata/models/scorm_page"

describe Konbata::ScormPage do
  before do
    @item = {
      source_package: nil,
      title: "Test Page",
      directory: fixture_path("scorm_page_files"),
      primary_file: "Volume1/primary_file.html",
      files: ["Volume1/primary_pdf.pdf"],
    }

    @page = Konbata::ScormPage.new(@item).canvas_page
  end

  describe "#_page_html" do
    it "reads the HTML from the primary file" do
      assert_includes(@page.body, "This is some test HTML.")
    end

    it "returns an empty string if there is no primary file" do
      @item[:primary_file] = "not_here.html"
      @page_without_primary_file = Konbata::ScormPage.new(@item).canvas_page

      assert(@page_without_primary_file.body.empty?)
    end
  end

  describe "#_remove_script_tags" do
    it "removes script tags" do
      refute(@page.body =~ /<script.*<\/script>/mi)
    end
  end

  describe "#_remove_unwanted_images" do
    it "removes help button images" do
      refute_includes(@page.body, '<img src="images/help_button.jpg">')
    end

    it "removes help button images" do
      refute_includes(@page.body, '<img src="images/exit_button.jpg">')
    end

    it "leaves other images alone" do
      assert_includes(@page.body, '<img src="images/keep_me.jpg">')
    end
  end

  describe "#_embed_pdf" do
    it "removes the iframe" do
      refute_includes(@page.body, "<iframe>This is an iframe.</iframe>")
    end

    it "adds the download link" do
      assert_includes(@page.body, "Download: <a href=")
    end

    it "uses the primary PDF" do
      assert_includes(@page.body, "Volume1/primary_pdf.pdf")
    end

    it "doesn't throw an error if there is no primary PDF" do
      @item[:files] = []
      @scorm_page = Konbata::ScormPage.new(@item)

      @scorm_page.canvas_page
    end
  end
end
