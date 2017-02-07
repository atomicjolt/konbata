require_relative "../helpers/spec_helper"

describe Konbata do
  before do
    @course_code = "course-code-001"
    volumes = {
      "1" => [
        File.join("path", "to", "doc1.doc"),
        File.join("path", "to", "doc2.docx"),
      ],
      "2" => [
        File.join("path", "to", "doc3.doc"),
        File.join("path", "to", "doc4.docx"),
      ],
    }

    @course = Konbata::Course.new(@course_code, volumes)
  end

  describe "Course" do
    it "should create a canvas_cc course" do
      canvas_course = @course.canvas_course

      assert(canvas_course.is_a?(CanvasCc::CanvasCC::Models::Course))
      assert_equal(@course_code, canvas_course.identifier)
      assert_equal(@course_code, canvas_course.course_code)
      assert_equal(@course_code, canvas_course.title)
      assert_equal(4, canvas_course.files.size)
      assert_equal(
        File.join("path", "to", "doc1.doc"),
        canvas_course.files.first.file_location,
      )
    end
  end
end
