require_relative "konbata/course"

module Konbata
  OUTPUT_DIR = "output".freeze
  # LIBRE_OFFICE_PATH =
  #   "/Applications/LibreOffice.app/Contents/MacOS/soffice".freeze
  #
  # def self.convert_to_html
  #   entries = Dir.glob("sources/**/*")
  #
  #   entries.each_with_index do |entry, index|
  #     next unless File.extname(entry) =~ /^\.docx?$/i
  #
  #     Libreconv.convert(
  #       entry,
  #       File.dirname(entry),
  #       LIBRE_OFFICE_PATH,
  #       "html",
  #     )
  #
  #     puts "#{index + 1}/#{entries.size} Finished #{entry}..."
  #   end
  # end

  def self.parse_course_directories
    entries = Dir.glob("sources/**/*")

    @courses = {}

    entries.each do |entry|
      next unless File.file?(entry)

      course = entry.split("/")[1].match(/Course - ([^,]+)/i)[1]
      volume = entry.split("/")[1].match(/Volume (\d+)/i)[1]
      file = File.absolute_path(entry)

      @courses[course] ||= Hash.new([])
      @courses[course][volume] |= [file]

      destination = "#{OUTPUT_DIR}/Course #{course}/Volume #{volume}"

      FileUtils.mkdir_p(destination)
      FileUtils.cp(entry, destination)
    end
  end
end
