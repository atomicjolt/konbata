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

module Konbata
  class NonInteractiveScormCourse < ScormCourse
    DEFAULT_VIEW = "modules".freeze

    ##
    # Creates and memoizes a canvas_cc course for the SCORM package.
    ##
    def canvas_course
      @canvas_course ||= begin
        canvas_course = _create_canvas_course(DEFAULT_VIEW)

        canvas_module = CanvasModule.create(@package.course_title)

        _items_to_pages.each do |page|
          canvas_course.pages << page.canvas_page
          _add_page_to_module(canvas_module, page)
        end

        canvas_course.canvas_modules << canvas_module

        canvas_course
      end
    end

    private

    ##
    # Creates a Canvas module item for the given file and adds it to the
    # given Canvas module.
    ##
    def _add_page_to_module(canvas_module, page)
      module_item = CanvasModuleItem.create(
        page.canvas_page.title,
        page.canvas_page.identifier,
        "WikiPage",
      )

      canvas_module.module_items << module_item
    end

    # Creates a ScormPage object for each element in @package.items and returns
    # them as an array.
    def _items_to_pages
      @package.items.map do |_, item_data|
        next if item_data[:title] =~ /orientation/i # Orientation is useless.

        Konbata::ScormPage.new(item_data)
      end.compact
    end
  end
end
