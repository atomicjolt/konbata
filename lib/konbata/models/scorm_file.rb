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
  class ScormFile
    attr_reader :canvas_file

    def initialize(file_path)
      @file_path = file_path
      @canvas_file = _create_canvas_file
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
      canvas_file.file_path = File.basename(@file_path)

      canvas_file
    end
  end
end
