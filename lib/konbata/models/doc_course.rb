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
require "konbata/reporter"
require "konbata/models/canvas_course"
require "konbata/models/canvas_module"
require "konbata/models/cover_page_file"
require "konbata/models/glossary_file"
require "konbata/models/unit_file"

module Konbata
  class DocCourse
    attr_reader :canvas_course

    def initialize(course_code, volumes)
      @volumes = volumes
      @canvas_course = _create_canvas_course(course_code)
    end

    private

    def _create_canvas_course(course_code)
      canvas_course = CanvasCourse.create(course_code)

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
        canvas_module = Konbata::CanvasModule.create(volume)

        source_files.each do |source_file|
          source_file.convert(canvas_course, canvas_module)

          Konbata::Reporter.complete_source_file(
            _source_file_index(source_file),
            _source_files_count,
          )
        end

        canvas_course.canvas_modules << canvas_module
      end
    end

    def _source_files_count
      @volumes.reduce(0) { |total, (_volume, files)| total + files.size }
    end

    def _source_file_index(source_file)
      @all_files ||= @volumes.reduce([]) { |all, (_volume, files)| all + files }
      @all_files.index(source_file)
    end
  end
end
