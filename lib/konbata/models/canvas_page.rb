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
  class CanvasPage
    ##
    # Creates and returns a canvas_cc page object.
    ##
    def self.create(title, body)
      page = CanvasCc::CanvasCC::Models::Page.new

      page.identifier = Konbata.create_random_hex
      page.workflow_state = "active"
      page.page_name = title
      page.body = body

      page
    end
  end
end
