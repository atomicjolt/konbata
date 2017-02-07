require "canvas_cc"
require "konbata/models/file"

module Konbata
  class Course
    attr_reader :canvas_course

    def initialize(course_code, volumes)
      @course_code = course_code
      @volumes = volumes
      @canvas_course = _create_canvas_course
    end

    private

    def _create_canvas_course
      canvas_course = CanvasCc::CanvasCC::Models::Course.new
      canvas_course.identifier = @course_code
      canvas_course.course_code = @course_code
      canvas_course.title = @course_code

      _add_source_files(canvas_course)

      canvas_course
    end

    def _add_source_files(canvas_course)
      @volumes.each do |volume, file_paths|
        file_paths.each do |file_path|
          source_file = Konbata::SourceFile.new(file_path, volume)

          canvas_course.files << source_file.canvas_file
        end
      end
    end
  end
end
