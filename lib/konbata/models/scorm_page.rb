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

require "konbata/models/canvas_page"

module Konbata
  class ScormPage
    def initialize(item)
      @item = item
    end

    ##
    # Creates a canvas_cc page for @item.
    ##
    def canvas_page
      @canvas_page ||= Konbata::CanvasPage.create(@item[:title], _page_html)
    end

    private

    ##
    # Returns the path to the primary PDF file for @item.
    # The primary PDF is the PDF file found at the top level of @item's folder.
    ##
    def _primary_pdf
      @primary_pdf ||= begin
        @item[:files].detect do |file|
          file.count(File::SEPARATOR) == 1 && File.extname(file) =~ /\.pdf/i
        end
      end
    end

    ##
    # Reads the contents of the item's primary file and returns a cleaned up
    # version.
    ##
    def _page_html
      primary_file_path = File.join(@item[:directory], @item[:primary_file])

      return "" unless File.exist?(primary_file_path)

      html = File.read(primary_file_path)
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
    # Removes the iframe and replaces it with the HTML to show the PDF for
    # @item.
    ##
    def _embed_pdf(html)
      pdf_html = <<~HEREDOC
        <p style="text-align: left">
          Download: <a href="#{_primary_pdf}">#{File.basename(_primary_pdf.to_s)}</a>
        </p>

        <div id="pdf_preview" style="height: 705px;" data-mimetype="application/pdf">
          <span id="replace_with_preview"><a href="#{_primary_pdf}"></a></span>
        </div>
      HEREDOC

      html.sub(/<iframe.*<\/iframe>/mi, pdf_html)
    end
  end
end
