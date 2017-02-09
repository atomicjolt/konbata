require "canvas_cc"

require "konbata/configuration"
require "konbata/models/course"

module Konbata
  INPUT_DIR = "sources".freeze
  OUTPUT_DIR = "output".freeze

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

    course_structures.each do |course_code, volumes|
      course = Konbata::Course.new(course_code, volumes)
      create_imscc(course)
    end
  end

  def self.create_imscc(course)
    imscc = CanvasCc::CanvasCC::CartridgeCreator.
      new(course.canvas_course).
      create(Dir.mktmpdir)

    FileUtils.cp(imscc, OUTPUT_DIR)
  end

  def self.generate_course_structures(entries)
    entries.each_with_object({}) do |entry, courses|
      next unless File.file?(entry)

      course = entry[/Course - ([^,]+)/i, 1]
      volume = entry[/Volume (\d+)/i, 1]
      file = File.absolute_path(entry)

      courses[course] ||= Hash.new([])
      courses[course][volume] |= [file]
    end
  end
end
