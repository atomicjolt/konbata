require "canvas_cc"
require "konbata/models/source_file"

module Konbata
  class Course
    attr_reader :canvas_course

    def initialize(course_code, volumes)
      @course_code = course_code
      @volumes = volumes
      @source_files = _create_source_files
      @canvas_course = _create_canvas_course
    end

    private

    def _create_source_files
      source_files = []

      @volumes.each do |volume, file_paths|
        file_paths.each do |file_path|
          if file_path[/glos/i]
            source_files << Konbata::GlossaryFile.new(file_path, volume)
          else
            source_files << Konbata::SourceFile.new(file_path, volume)
          end
        end
      end

      source_files
    end

    def _create_canvas_course
      canvas_course = CanvasCc::CanvasCC::Models::Course.new
      canvas_course.identifier = @course_code
      canvas_course.course_code = @course_code
      # TODO: Add real course title.
      canvas_course.title = @course_code

      _add_raw_source_files(canvas_course)
      _convert_source_files(canvas_course)

      canvas_course
    end

    def _add_raw_source_files(canvas_course)
      @source_files.each do |source_file|
        canvas_course.files << source_file.canvas_file
      end
    end

    def _convert_source_files(canvas_course)
      @source_files.each do |source_file|
        source_file.convert(canvas_course)
      end
    end
  end
end
