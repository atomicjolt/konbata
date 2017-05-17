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

require "rake"
require "rake/clean"
require "konbata"
require "konbata/error_logger"

##
# Creates rake tasks that can be ran from the gem.
#
# Add this to your Rakefile
#
#   require "konbata/tasks"
#   Konbata::Tasks.install_tasks
##

def validate_type_arg(type)
  return if %w{interactive non_interactive pdfs}.include?(type)

  puts "ERROR: Must pass 'interactive', 'non_interactive' or 'pdfs' as an " \
  "argument to the task."

  exit
end

module Konbata
  class Tasks
    extend Rake::DSL if defined? Rake::DSL

    def self.install_tasks
      namespace :konbata do
        desc "Find and process zip archives, accepts 'interactive', " \
        "'non_interactive' or 'pdfs' as an argument."
        task :convert, [:type] do |_, args|
          validate_type_arg(args[:type])
          type = args[:type].to_sym

          Konbata.convert_zips(type)
        end

        desc "Upload .imscc files to Canvas, accepts 'interactive', " \
        "'non_interactive' or 'pdfs' as an argument."
        task :upload, [:type] do |_, args|
          validate_type_arg(args[:type])
          type = args[:type].to_sym

          Konbata.upload_courses(type)
        end

        desc "Destroy output and log folders."
        task :clean do
          if Dir.exist?(Konbata::OUTPUT_DIR)
            remove_entry_secure(Konbata::OUTPUT_DIR)
          end

          log_dir = File.dirname(ErrorLogger::LOG_FILEPATH)
          if Dir.exist?(log_dir)
            remove_entry_secure(log_dir)
          end
        end
      end
    end
  end
end
