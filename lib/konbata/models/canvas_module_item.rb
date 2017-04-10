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
  class CanvasModuleItem
    ##
    # Creates and returns a canvas_cc module item object.
    ##
    def self.create(title, identifierref)
      module_item = CanvasCc::CanvasCC::Models::ModuleItem.new
      module_item.identifier = Konbata.create_random_hex
      module_item.workflow_state = "active"
      module_item.content_type = "WikiPage"
      module_item.title = title
      module_item.identifierref = identifierref

      module_item
    end
  end
end
