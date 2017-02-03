require "rake"
require "rake/clean"
require "konbata"

module Konbata
  class Tasks
    extend Rake::DSL if defined? Rake::DSL

    OUTPUT_DIR = "output".freeze

    ##
    # Creates rake tasks that can be ran from the gem.
    #
    # Add this to your Rakefile
    #
    #   require "konbata/tasks"
    #   Senkyoshi::Tasks.install_tasks
    #
    ##
    def self.install_tasks
      namespace :konbata do
        desc "Generate a barebones Canvas course from source directory."
        task :imscc do
          Konbata.parse_course_directories
          Konbata.create_courses
        end

        desc "Destroy output folder."
        task :clean do
          rm_rf OUTPUT_DIR
        end
      end
    end
  end
end
