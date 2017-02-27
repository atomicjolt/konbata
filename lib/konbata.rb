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
require "konbata/reporter"
require "konbata/models/doc_course"
require "konbata/models/scorm_course"
require "konbata/models/upload_course"

module Konbata
  INPUT_DIR = "sources".freeze
  OUTPUT_DIR = "canvas".freeze
  FILE_BASE = "$IMS_CC_FILEBASE$".freeze

  def self.configuration
    @configuration ||= Configuration.new
  end

  ##
  # Create a random hex prepended with aj_
  # This is because the instructure qti migration tool requires
  # the first character to be a letter.
  ##
  def self.create_random_hex
    "aj_" + SecureRandom.hex(32)
  end

  def self.convert_courses
    FileUtils.mkdir_p(OUTPUT_DIR)

    docs = Dir.glob("#{INPUT_DIR}/**/*.{doc,docx}")

    course_structures = generate_course_structures(docs)

    course_structures.each_with_index do |(course_code, volumes), index|
      Konbata::Reporter.start_course(course_code, index, course_structures.size)

      course = Konbata::Course.new(course_code, volumes)
      create_imscc(course)

      Konbata::Reporter.complete_course(course_code)
    end
  end

  def self.create_scorm
    FileUtils.mkdir_p(OUTPUT_DIR)
    scorm_package_paths = Dir.glob("#{INPUT_DIR}/*.zip")

    scorm_package_paths.each do |package_path|
      course = ScormCourse.new(package_path)
      create_imscc(course)
    end
  end

  def self.create_imscc(course)
    imscc = CanvasCc::CanvasCC::CartridgeCreator.
      new(course.canvas_course).
      create(Dir.mktmpdir)
    # Renaming imscc file name to match source file since CanvasCC changes it
    FileUtils.cp(imscc, "#{OUTPUT_DIR}/#{course.canvas_course.title}.imscc")
  end

  ##
  # Returns a hash where each key is the course code and each value for the
  # course code is a nested hash.
  # The nested hashes have volume numbers for keys and an array of source file
  # paths for that volume as the values.
  # It also sorts the file path arrays so that module items are created and
  # added in the right order.
  ##
  def self.generate_course_structures(entries)
    course_structures = entries.each_with_object({}) do |entry, courses|
      next unless File.file?(entry)

      course = entry[/Course - ([^,]+)/i, 1]
      volume = entry[/Volume (\d+)/i, 1]
      file = File.absolute_path(entry)

      courses[course] ||= Hash.new([])
      courses[course][volume] |= [file]
    end

    course_structures.each do |course_code, volumes|
      course_structures[course_code] = volumes.sort.to_h
      volumes.each do |_volume, file_paths|
        file_paths.sort! do |a, b|
          File.basename(a).downcase <=> File.basename(b).downcase
        end
      end
    end
  end

  def self.initialize_course(canvas_file_path, source_for_imscc)
    metadata = Konbata::UploadCourse.metadata_from_file(canvas_file_path)
    course = Konbata::UploadCourse.from_metadata(metadata)
    course.upload_content(canvas_file_path, source_for_imscc)
  end
end
