require "canvas_cc"
require "zip"

require "konbata/configuration"
require "konbata/reporter"
require "konbata/models/canvas_course"
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

  def self.create_imscc(course)
    imscc = CanvasCc::CanvasCC::CartridgeCreator.
      new(course.canvas_course).
      create(Dir.mktmpdir)

    FileUtils.cp(imscc, OUTPUT_DIR)
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

    course_structures.each do |_course_code, volumes|
      volumes.each do |_volume, file_paths|
        file_paths.sort! do |a, b|
          File.basename(a).downcase <=> File.basename(b).downcase
        end
      end
    end
  end

  def self.initialize_course(canvas_file_path)
    metadata = Konbata::UploadCourse.metadata_from_file(canvas_file_path)
    course = Konbata::UploadCourse.from_metadata(metadata)
    course.upload_content(canvas_file_path)
  end
end
