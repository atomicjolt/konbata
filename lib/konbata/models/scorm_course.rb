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

require "zip"
require "konbata/models/canvas_course"
require "konbata/models/scorm_package"
require "konbata/models/scorm_file"

module Konbata
  class ScormCourse
    attr_reader :canvas_course

    def initialize(package_path)
      @package = Konbata::ScormPackage.new(package_path)
      @canvas_course = _create_canvas_course
    end

    private

    def _create_canvas_course
      canvas_course = Konbata::CanvasCourse.create(
        File.basename(@package.filepath, ".zip"),
        course_code: @package.course_code,
        default_view: "assignments",
      )

      scorm_file = Konbata::ScormFile.new(@package.filepath)

      canvas_course.files << scorm_file.canvas_file
      _scorm_pdfs.each { |file| canvas_course.files << file.canvas_file }

      canvas_course
    end

    ##
    # Iterates through the SCORM package and detects any PDF files. A ScormFile
    # object will be generated for each PDF found, and an array of ScormFile
    # objects is returned.
    ##
    def _scorm_pdfs
      temp_dir = Dir.mktmpdir

      @package.pdfs.map do |entry|
        extract_to = File.join(temp_dir, File.basename(entry.name))
        entry.extract(extract_to)
        Konbata::ScormFile.new(extract_to)
      end
    end
  end
end
