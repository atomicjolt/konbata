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
  class Reporter
    def self.start_course(course, index, total)
      puts center("Starting course #{course} (#{index + 1}/#{total})")
    end

    def self.complete_course(course)
      puts center("Completed course #{course}")
    end

    def self.complete_source_file(index, total)
      puts "  >> Completed source file #{index + 1} of #{total}"
    end

    def self.center(message)
      message.center(55, "-")
    end
  end
end
