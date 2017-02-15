require_relative "../helpers/spec_helper"

describe Konbata do
  before do
    @metadata =
      Konbata::UploadCourse.metadata_from_file(fixture_path("IMSCC.imscc"))
  end

  describe "UploadCourse" do
    describe "metadata_from_file" do
      it "should fetch course title from imscc xml settings file" do
        assert_equal("Course Title", @metadata[:title])
      end
      it "should fetch course code from imscc xml settings file" do
        assert_equal("0A123", @metadata[:course_code])
      end
    end
  end
end
