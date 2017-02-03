require "canvas_cc"

module Konbata
  def self.volume_path(volume)
    "/Volume #{volume}"
  end

  def self.create_courses
    @courses.each do |course, volumes|
      canvas_course = CanvasCc::CanvasCC::Models::Course.new

      canvas_course.identifier = course
      canvas_course.course_code = course
      canvas_course.title = course

      volumes.each do |volume, files|
        files.each do |file|
          canvas_file = CanvasCc::CanvasCC::Models::CanvasFile.new
          canvas_file.identifier = file.hash.abs
          canvas_file.file_location = file
          canvas_file.hidden = false
          canvas_file.file_path = "#{Konbata.volume_path(volume)}/" \
                                  "#{File.basename(file)}"

          canvas_course.files << canvas_file
        end
      end

      dir = Dir.mktmpdir
      imscc = CanvasCc::CanvasCC::CartridgeCreator.new(canvas_course).create(dir)
      FileUtils.cp(imscc, "output")
    end
  end
end
