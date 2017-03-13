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
    # Reads the content from the item's primary file.
    ##
    def _page_html
      html = File.read(File.join(@item.directory, @item.primary_file))

      html.gsub(/<script.*<\/script>/mi, "")
      html = _remove_unwanted_images(html)

      html
    end

    def _remove_unwanted_images(html)
      html_nodes = Nokogiri::HTML(html)

      html_nodes.search(:img).each do |img|
        img.remove if img.attr(:src) =~ /(help|exit)_button/i
      end

      html_nodes.to_html
    end
  end
end
