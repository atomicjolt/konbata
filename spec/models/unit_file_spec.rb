require_relative "../helpers/spec_helper"

describe Konbata do
  describe "UnitFile" do
    describe "initialize" do
      before do
        file_path = fixture_path("u1.doc")
        @volume = "3"

        @cover_page_file = MockUnitFile.new(file_path, @volume)
        @canvas_course = CanvasCc::CanvasCC::Models::Course.new
        @canvas_module = Konbata::Module.create(@volume)
        @cover_page_file.convert(@canvas_course, @canvas_module)
      end

      it "should create a title" do
        assert_equal(
          "Unit 1 (Vol. #{@volume})",
          @canvas_module.module_items.first.title,
        )
      end
    end
  end
end
