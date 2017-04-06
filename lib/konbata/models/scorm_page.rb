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

module Konbata
  class ScormPage
    attr_reader :canvas_page

    def initialize(item)
      @item = item
    end

    ##
    # Creates and populates a canvas_cc page.
    ##
    def canvas_page
      @canvas_page ||= begin
        page = CanvasCc::CanvasCC::Models::Page.new
        page.identifier = Konbata.create_random_hex
        page.workflow_state = "active"
        page.page_name = @item.title
        page.body = _page_html

        page
      end
    end

    private

    ##
    # Returns the path to the primary PDF file for @item.
    # The primary PDF is the PDF file found at the top level of @item's folder.
    ##
    def _primary_pdf
      pdf = @item.files.detect do |file|
        file.count(File::SEPARATOR) == 1 && File.extname(file) =~ /\.pdf/i
      end

      pdf
    end

    ##
    # Reads and modifies the content from the item's primary file.
    ##
    def _page_html
      html = File.read(File.join(@item.directory, @item.primary_file))

      html = _remove_script_tags(html)
      html = _remove_unwanted_images(html)
      html = _embed_pdf(html)

      html
    end

    ##
    # Removes all script tags from the given HTML.
    ##
    def _remove_script_tags(html)
      html.gsub(/<script.*<\/script>/mi, "")
    end

    ##
    # Removes the help and exit button images from the given HTML.
    ##
    def _remove_unwanted_images(html)
      html_nodes = Nokogiri::HTML(html)

      html_nodes.search(:img).each do |img|
        img.remove if img.attr(:src) =~ /(help|exit)_button/i
      end

      html_nodes.to_html
    end

    ##
    # Removes the iframe and adds the HTML to show the PDF for @item.
    ##
    def _embed_pdf(html)
      pdf_html = <<~HEREDOC
        <p style="text-align: left">
          Download: <a href="#{_primary_pdf}">#{File.basename(_primary_pdf)}</a>
        </p>
      HEREDOC

      html.sub(/<iframe.*<\/iframe>/mi, pdf_html)
    end
  end
end
