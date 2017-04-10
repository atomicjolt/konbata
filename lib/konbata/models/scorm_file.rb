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

require "konbata/models/canvas_file"

module Konbata
  class ScormFile
    def initialize(local_file_path, canvas_file_path = nil)
      @local_file_path = local_file_path # Location in local filesystem.
      @canvas_file_path = canvas_file_path # Location inside Canvas.
    end

    ##
    # Creates and populates a canvas_cc CanvasFile.
    ##
    def canvas_file
      @canvas_file ||= begin
        Konbata::CanvasFile.create(
          @local_file_path,
          @canvas_file_path,
        )
      end
    end
  end
end
