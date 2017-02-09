require "canvas_cc"
require "konbata/models/module"
require "konbata/models/cover_page_file"
require "konbata/models/glossary_file"
require "konbata/models/unit_file"

module Konbata
  class Course
    attr_reader :canvas_course

    def initialize(course_code, volumes)
      @volumes = volumes
      @canvas_course = _create_canvas_course(course_code)
    end

    private

    def _create_canvas_course(course_code)
      canvas_course = CanvasCc::CanvasCC::Models::Course.new
      canvas_course.identifier = course_code
      canvas_course.course_code = course_code
      # TODO: Add real course title.
      canvas_course.title = course_code

      _instantiate_source_files
      _add_raw_source_files(canvas_course)
      _convert_source_files(canvas_course)

      canvas_course
    end

    def _instantiate_source_files
      @volumes.each do |volume, file_paths|
        file_paths.map! do |file_path|
          if file_path[/front/i]
            Konbata::CoverPageFile.new(file_path, volume)
          elsif file_path[/glos/i]
            Konbata::GlossaryFile.new(file_path, volume)
          elsif file_path[/U\d+/i]
            Konbata::UnitFile.new(file_path, volume)
          end
        end.compact!
      end
    end

    def _add_raw_source_files(canvas_course)
      @volumes.each do |_, source_files|
        source_files.each do |source_file|
          canvas_course.files << source_file.canvas_file
        end
      end
    end

    def _convert_source_files(canvas_course)
      @volumes.each do |volume, source_files|
        canvas_module = Konbata::Module.create(volume)

        source_files.each do |source_file|
          source_file.convert(canvas_course, canvas_module)
        end

        canvas_course.canvas_modules << canvas_module
      end
    end
  end
end
