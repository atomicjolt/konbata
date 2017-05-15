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

require "logger"

class ErrorLogger
  DEFAULT_LOG_FILEPATH = File.join("canvas", "conversion_errors.log").freeze

  def initialize(log_filepath = nil)
    @log_filepath = log_filepath || DEFAULT_LOG_FILEPATH

    FileUtils.mkdir_p(File.dirname(@log_filepath))
    File.open(@log_filepath, "w") {}
  end

  def log_error(message)
    File.open(@log_filepath, "w+") { |file| file.puts(message) }
  end

  def notify_if_errors
    return if empty_log?

    puts "WARNING: There were some conversion errors. Check " \
    "`#{@log_filepath}` for details."
  end

  def empty_log?
    File.read(@log_filepath).empty?
  end
end
