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
  class CanvasFile
    ##
    # Creates and returns a canvas_cc file object.
    ##
    def self.create(local_file_path, canvas_file_path)
      canvas_file = CanvasCc::CanvasCC::Models::CanvasFile.new

      canvas_file.identifier = Konbata.create_random_hex
      canvas_file.hidden = false
      canvas_file.file_location = local_file_path
      canvas_file.file_path = canvas_file_path || File.basename(local_file_path)

      canvas_file
    end
  end
end
