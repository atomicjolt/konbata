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

require_relative "../helpers/spec_helper"
require "konbata/models/upload_course"

describe Konbata::UploadCourse do
  before do
    @metadata =
      Konbata::UploadCourse.metadata_from_file(fixture_path("IMSCC.imscc"))
  end

  describe "#metadata_from_file" do
    it "fetches course title from imscc xml settings file" do
      assert_equal("Course Title", @metadata[:title])
    end

    it "fetches course code from imscc xml settings file" do
      assert_equal("0A123", @metadata[:course_code])
    end
  end

  describe "#scorm_launch_url" do
    it "returns the correct launch URL" do
      upload_course = Konbata::UploadCourse.new(
        Konbata::CanvasCourse.create("Test"),
      )
      package_id = "123"

      assert_equal(
        upload_course.scorm_launch_url(package_id),
        "#{Konbata.configuration.scorm_launch_url}?course_id=#{package_id}",
      )
    end
  end
end
