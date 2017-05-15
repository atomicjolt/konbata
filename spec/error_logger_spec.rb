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
    @log_filepath = File.join(Dir.mktmpdir, "conversion_errors.log")
  end

  describe ".initialize" do
    it "creates a log file if it doesn't exist" do
      ErrorLogger.new(@log_filepath)

      assert(File.exist?(@log_filepath))
    end

    it "clears out the log file contents" do
      File.open(@log_filepath, "w") do |file|
        file << "Just some stuff."
      end

      ErrorLogger.new(@log_filepath)

      assert_empty(File.read(@log_filepath))
    end
  end

  describe "#log_error" do
    it "adds the given error message to the log" do
      logger = ErrorLogger.new(@log_filepath)

      message = "Storm's approaching fast!"
      logger.log_error(message)

      assert_includes(File.read(@log_filepath), message)
    end
  end

  describe "#notify_if_errors" do
    before do
      @logger = ErrorLogger.new(@log_filepath)
    end

    it "notifies the user if there were conversion errors" do
      @logger.log_error("Man overboard! The ship is sinking!")

      assert_output(/WARNING: There were some conversion errors/i) do
        @logger.notify_if_errors
      end
    end

    it "doesn't notify the user if there weren't errors" do
      assert_output("") { @logger.notify_if_errors }
    end
  end

  describe "#empty_log?" do
    before do
      @logger = ErrorLogger.new(@log_filepath)
    end

    it "returns true if the log file is empty" do
      assert(@logger.empty_log?)
    end

    it "returns false if the log file isn't empty" do
      @logger.log_error("Winds have increased 10 fold! And smell like tacos!")

      refute(@logger.empty_log?)
    end
  end
end
