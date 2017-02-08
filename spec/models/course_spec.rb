require_relative "../helpers/spec_helper"

describe Konbata do
  before do
    @course_code = "course-code-001"
    volumes = {
      "1" => [
        fixture_path("front.doc"),
      ],
      "2" => [
        fixture_path("glos.doc"),
        fixture_path("u1.doc"),
      ],
    }

    @course = MockCourse.new(@course_code, volumes)
  end

  describe "Course" do
    it "should create a canvas_cc course" do
      assert(@course.canvas_course.is_a?(CanvasCc::CanvasCC::Models::Course))
    end

    it "should give the canvas_cc course an identifier" do
      assert_equal(@course_code, @course.canvas_course.identifier)
    end

    it "should give the canvas_cc course a course code" do
      assert_equal(@course_code, @course.canvas_course.course_code)
    end

    it "should give the canvas_cc course a title" do
      assert_equal(@course_code, @course.canvas_course.title)
    end

    it "should populate canvas_cc course with files" do
      assert_equal(3, @course.canvas_course.files.size)
      assert_equal(
        File.join(fixture_path("front.doc")),
        @course.canvas_course.files.first.file_location,
      )
    end
  end
end
