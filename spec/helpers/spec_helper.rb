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

require "minitest/autorun"
require "minitest/reporters"
Minitest::Reporters.use!

require "konbata"
require_relative "../mocks/mock_course"
require_relative "../mocks/mock_cover_page_file"
require_relative "../mocks/mock_glossary_file"
require_relative "../mocks/mock_source_file"
require_relative "../mocks/mock_unit_file"

def fixture_path(fixture)
  File.absolute_path(File.join("spec", "fixtures", fixture))
end

# Suppress reporting.
module Kernel
  def puts(*); end
end
