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

require "helpers/spec_helper"
require "konbata/error_logger"

describe "ErrorLogger" do
  before do
    @log_filepath = File.join("canvas", "conversion_errors.log")
  end

  after do
    FileUtils.remove_entry_secure(@log_filepath) if File.exist?(@log_filepath)
  end

  describe ".setup" do
    it "creates a log file if it doesn't already exist" do
      ErrorLogger.setup

      assert(File.exist?(@log_filepath))
    end

    it "clears out the log file contents" do
      File.open(@log_filepath, "w") do |file|
        file << "Just some stuff."
      end

      ErrorLogger.setup

      assert_empty(File.read(@log_filepath))
    end
  end

  describe ".log" do
    it "adds the given error message to the log" do
      ErrorLogger.setup

      message = "Storm's approaching fast!"
      ErrorLogger.log(message)

      assert_includes(File.read(@log_filepath), message)
    end
  end

  describe ".notify_or_remove" do
    before do
      ErrorLogger.setup
    end

    it "notifies the user if there were conversion errors" do
      ErrorLogger.log("Man overboard! The ship is sinking!")

      assert_output(/WARNING: There were some conversion errors/i) do
        ErrorLogger.notify_or_remove
      end
    end

    it "doesn't notify the user if there weren't errors" do
      assert_output("") { ErrorLogger.notify_or_remove }
    end

    it "removes the log file if there weren't errors" do
      ErrorLogger.notify_or_remove

      refute(File.exist?(@log_filepath))
    end
  end

  describe ".empty_log?" do
    before do
      ErrorLogger.setup
    end

    it "returns true if the log file is empty" do
      assert(ErrorLogger.empty_log?)
    end

    it "returns false if the log file isn't empty" do
      ErrorLogger.log("The winds have increased 10 fold!")

      refute(ErrorLogger.empty_log?)
    end
  end
end
