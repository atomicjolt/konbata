require "rake"
require "rake/clean"
require "konbata"

UPLOAD_DIR = "uploaded".freeze

## Don't change these, these are just getting the last
## of the folder name for the script below to use
OUTPUT_NAME = Konbata::OUTPUT_DIR.split("/").last
UPLOAD_NAME = UPLOAD_DIR.split("/").last
CONVERTED_FILES = Rake::FileList.new("#{Konbata::OUTPUT_DIR}/*.imscc")

##
# Creates rake tasks that can be ran from the gem.
#
# Add this to your Rakefile
#
#   require "konbata/tasks"
#   Senkyoshi::Tasks.install_tasks
#
##

def source_for_upload_log(upload_log)
  CONVERTED_FILES.detect do |f|
    path = upload_log.pathmap("%{^#{UPLOAD_DIR}/,#{Konbata::OUTPUT_DIR}/}X")
    f.ext("") == path
  end
end

def make_directories(name, upload_dir)
  mkdir_p name.pathmap("%d")
  mkdir_p upload_dir
end

def log_file(name)
  sh "touch #{name}"
  sh "date >> #{name}"
end

module Konbata
  class Tasks
    extend Rake::DSL if defined? Rake::DSL

    def self.install_tasks
      namespace :konbata do
        desc "Generate Canvas courses from folders in source directory."
        task :imscc do
          Konbata.convert_courses
        end

        desc "Upload converted files to canvas"
        task upload: CONVERTED_FILES.pathmap(
          "%{^#{OUTPUT_NAME}/,#{UPLOAD_DIR}/}X.txt",
        )

        directory UPLOAD_NAME

        rule ".txt" => [->(f) { source_for_upload_log(f) }, UPLOAD_NAME] do |t|
          make_directories(t.name, UPLOAD_DIR)
          Konbata.initialize_course(t.source)
          log_file(t.name)
        end

        desc "Destroy output folder."
        task :clean do
          if Dir.exist?(Konbata::OUTPUT_DIR)
            remove_entry_secure(Konbata::OUTPUT_DIR)
          end
        end
      end
    end
  end
end
