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

module ErrorLogger
  LOG_FILEPATH = File.join("canvas", "conversion_errors.log").freeze

  def self.setup
    FileUtils.mkdir_p(File.dirname(LOG_FILEPATH))
    File.open(LOG_FILEPATH, "w") {}
  end

  def self.log(message)
    File.open(LOG_FILEPATH, "a") do |file|
      file << "#{Time.now} - #{message}\n\n"
    end
  end

  def self.log_missing_file(file, zip_file)
    message = "The manifest for \"#{File.basename(zip_file)}\" included a " \
    "reference to \"#{file}\", but that file could not be found in the " \
    "zip file. The content associated with that file is likely broken."

    log(message)
  end

  def self.empty_log?
    File.read(LOG_FILEPATH).empty?
  end

  def self.notify_or_remove
    if empty_log?
      FileUtils.remove_entry_secure(LOG_FILEPATH)
    else
      puts "*** WARNING: There were some conversion errors. Check " \
      "`#{LOG_FILEPATH}` for details. ***"
    end
  end
end
