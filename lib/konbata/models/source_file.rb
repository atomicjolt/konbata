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

require "canvas_cc"
require "libreconv"
require "konbata/models/canvas_module_item"

module Konbata
  class SourceFile
    attr_reader :canvas_file

    HTML_FILE_PATTERN = /\.html?$/i
    SOURCE_IMAGE_OUTPUT = "source_file_images".freeze

    def initialize(file_path, volume)
      @file_path = file_path
      @volume = volume
      @canvas_file = _create_canvas_file
      # @title may be overwritten by subclass.
      @title = File.basename(file_path).
        sub(/\.docx?$/i, ""). # Remove .doc or .docx file extension.
        sub(/\(\d{1,2}\)/, ""). # Remove (1), (2), etc. in file name.
        strip
    end

    ##
    # Creates a canvas_cc page and adds it to the canvas_course.
    # Creates a canvas_cc module_item and adds it to the canvas_module.
    ##
    def convert(canvas_course, canvas_module)
      html_output_dir = _convert_to_html
      _copy_html_images(html_output_dir, canvas_course)

      page = CanvasCc::CanvasCC::Models::Page.new
      page.identifier = Konbata.create_random_hex
      page.workflow_state = "active"
      page.page_name = @title
      page.body = _html_text(html_output_dir)

      module_item = Konbata::ModuleItem.create(
        @title,
        page.identifier,
      )

      canvas_module.module_items << module_item
      canvas_course.pages << page
    end

    private

    ##
    # Creates and populates a canvas_cc CanvasFile.
    ##
    def _create_canvas_file
      canvas_file = CanvasCc::CanvasCC::Models::CanvasFile.new

      canvas_file.identifier = Konbata.create_random_hex
      canvas_file.file_location = @file_path
      canvas_file.hidden = false
      canvas_file.file_path = File.join(
        "Volume #{@volume}", File.basename(@file_path).to_s
      )

      canvas_file
    end

    ##
    # Converts the file at @file_path to HTML and returns the output directory
    # as a Pathname object.
    ##
    def _convert_to_html
      output_dir = Pathname.new(Dir.mktmpdir)

      Libreconv.convert(
        @file_path,
        output_dir.to_path,
        Konbata.configuration.libre_office_path,
        "html",
      )

      output_dir
    end

    ##
    # Returns the contents of the HTML file in the output_dir as text.
    # Also changes any <img> tags `src` attributes to the correct path.
    # Ensures no elements are absolutely positioned.
    ##
    def _html_text(output_dir)
      html_file = output_dir.children.detect do |file|
        file.to_path[HTML_FILE_PATTERN]
      end

      node_html = Nokogiri::HTML.fragment(html_file.read)
      node_html.search("img").each do |image_tag|
        fixed_src = File.join(FILE_BASE, SOURCE_IMAGE_OUTPUT, image_tag["src"])
        image_tag["src"] = fixed_src
      end

      node_html.to_s.gsub(/position: absolute;?/i, "")
    end

    ##
    # Iterates through every image in the output_dir, turns them into canvas_cc
    # CanvasFiles and adds them to the canvas_course files.
    ##
    def _copy_html_images(output_dir, canvas_course)
      output_dir.each_child(with_directory: false) do |file|
        next if file.to_path[HTML_FILE_PATTERN]

        canvas_file = CanvasCc::CanvasCC::Models::CanvasFile.new
        canvas_file.identifier = Konbata.create_random_hex
        canvas_file.file_location = file.to_path
        canvas_file.hidden = true
        canvas_file.file_path = File.join(SOURCE_IMAGE_OUTPUT, file.basename)

        canvas_course.files << canvas_file
      end
    end
  end
end
