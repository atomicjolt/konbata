require_relative "../helpers/spec_helper"

describe Konbata do
  describe "GlossaryFile" do
    before do
      @glossary_file = MockGlossaryFile.new(fixture_path("glos.doc"), "1")
      @canvas_course = CanvasCc::CanvasCC::Models::Course.new
      @glossary_file.convert(@canvas_course)
    end

    it "should add a canvas_cc page to the canvas_cc course given" do
      assert_equal(1, @canvas_course.pages.size)

      assert_equal(
        CanvasCc::CanvasCC::Models::Page,
        @canvas_course.pages.first.class,
      )
    end

    it "should give the canvas_cc page an identifier" do
      refute_nil(@canvas_course.pages.first.identifier)
    end

    it "should give the canvas_cc page a workflow state of 'active'" do
      assert_equal("active", @canvas_course.pages.first.workflow_state)
    end

    it "should give the page a body" do
      assert_includes(
        @canvas_course.pages.first.body,
        "glossary file converted to HTML",
      )
    end
  end
end
