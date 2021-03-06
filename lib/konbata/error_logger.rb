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
  LOG_FILEPATH = File.join("log", "conversion_errors.log").freeze

  ##
  # Creates an empty log file.
  ##
  def self.setup
    FileUtils.mkdir_p(File.dirname(LOG_FILEPATH))
    File.open(LOG_FILEPATH, "w") {}
  end

  ##
  # Adds the given message to the log.
  # Doesn't add the message if it's already in the log.
  ##
  def self.log(message)
    return if File.read(LOG_FILEPATH).include?(message) # Don't repeat messages.

    File.open(LOG_FILEPATH, "a") do |file|
      file << "#{Time.now} - #{message}\n\n"
    end
  end

  ##
  # Add a log message for a file missing from the zip file.
  ##
  def self.log_missing_file(file, zip_file)
    message = "The manifest for \"#{File.basename(zip_file)}\" included a " \
    "reference to \"#{file}\", but that file could not be found in the " \
    "zip file. The content associated with that file is likely broken."

    log(message)
  end

  ##
  # Add a log message for a missing primary file.
  ##
  def self.log_no_primary_file(item_title, zip_file, file_type)
    message = "A primary #{file_type} could not be found for item " \
    "\"#{item_title}\" in \"#{File.basename(zip_file)}\". The content " \
    "associated with that item is likely broken."

    log(message)
  end

  ##
  # Add a log message for a missing primary PDF.
  ##
  def self.log_no_primary_pdf(item_title, zip_file)
    log_no_primary_file(item_title, zip_file, "PDF")
  end

  ##
  # Add a log message for a missing primary HTML file.
  ##
  def self.log_no_primary_html(item_title, zip_file)
    log_no_primary_file(item_title, zip_file, "HTML file")
  end

  ##
  # Return whether or not the log file is empty.
  ##
  def self.empty_log?
    File.read(LOG_FILEPATH).empty?
  end

  ##
  # Notify the user that there are messages in the log file.
  # Otherwise, remove the empty file.
  ##
  def self.notify_or_remove
    if empty_log?
      FileUtils.remove_entry_secure(LOG_FILEPATH)
    else
      puts "*** WARNING: There were some conversion errors. Check " \
      "`#{LOG_FILEPATH}` for details. ***"
    end
  end
end
