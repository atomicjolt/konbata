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
        desc "Generate Canvas courses from folders in source directory."
        task :imscc do
          Konbata.convert_courses
        end

        desc "Destroy output folder."
        task :clean do
          remove_entry_secure(OUTPUT_DIR)
        end
      end
    end
  end
end
