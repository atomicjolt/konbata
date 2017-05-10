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

require "canvas_cc"
require "zip"

require "konbata/configuration"
require "konbata/models/scorm_course"
require "konbata/models/interactive_scorm_course"
require "konbata/models/non_interactive_scorm_course"
require "konbata/models/upload_course"

module Konbata
  INPUT_DIR = "sources".freeze
  OUTPUT_DIR = "canvas".freeze
  FILE_BASE = "$IMS_CC_FILEBASE$".freeze

  def self.configuration
    @configuration ||= Konbata::Configuration.new
  end

  ##
  # Create a random hex prepended with aj_
  # This is because the instructure qti migration tool requires
  # the first character to be a letter.
  ##
  def self.create_random_hex
    "aj_" + SecureRandom.hex(32)
  end

  ##
  # Iterates through every SCORM package in the sources directory and converts
  # them to a Canvas .imscc file.
  ##
  def self.convert_scorm(type)
    FileUtils.mkdir_p(OUTPUT_DIR)

    scorm_package_paths = Dir.glob("#{INPUT_DIR}/*.zip")

    scorm_package_paths.each do |package_path|
      puts "Converting #{File.basename(package_path)}"

      # Formats path to not have any spaces as the SCORM upload can't handle it.
      formatted_path = package_path.gsub(/\s/, "_")
      if formatted_path != package_path
        File.rename(package_path, formatted_path)
        package_path = formatted_path
      end

      klass = "Konbata::#{type.to_s.camelize}ScormCourse".constantize
      course = klass.new(package_path)

      create_imscc(course)
      course.cleanup
    end
  end

  ##
  # Creates an .imscc file for the given course object.
  ##
  def self.create_imscc(course)
    imscc = CanvasCc::CanvasCC::CartridgeCreator.
      new(course.canvas_course).
      create(Dir.mktmpdir)

    FileUtils.cp(imscc, OUTPUT_DIR)
    FileUtils.remove_entry_secure(imscc)
  end

  ##
  # Uploads all .imscc files in the canvas directory to Canvas.
  ##
  def self.upload_courses(type)
    imscc_paths = Dir.glob("#{OUTPUT_DIR}/*.imscc")

    imscc_paths.each { |imscc| Konbata.upload_course(imscc, type) }
  end

  ##
  # Uploads a course to Canvas.
  ##
  def self.upload_course(imscc_file_path, type)
    metadata = Konbata::UploadCourse.metadata_from_file(imscc_file_path)
    course = Konbata::UploadCourse.from_metadata(metadata, type)
    source_for_imscc = "#{INPUT_DIR}/#{metadata[:title]}.zip"
    course.upload_content(imscc_file_path, source_for_imscc)
  end
end
