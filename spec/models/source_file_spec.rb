require_relative "../helpers/spec_helper"

describe Konbata do
  describe "SourceFile" do
    before do
      @file_path = fixture_path("front.doc")
      volume = "2"

      @source_file = MockSourceFile.new(@file_path, volume)
      @canvas_course = CanvasCc::CanvasCC::Models::Course.new
      @canvas_module = Konbata::Module.create(volume)
      @source_file.convert(@canvas_course, @canvas_module)
    end

    describe "convert" do
      it "should add a canvas_cc page to the canvas_cc course given" do
        assert_equal(1, @canvas_course.pages.size)

        assert(
          @canvas_course.pages.first.is_a?(CanvasCc::CanvasCC::Models::Page),
        )
      end

      it "should give the canvas_cc page an identifier" do
        refute_nil(@canvas_course.pages.first.identifier)
      end

      it "should give the canvas_cc page a workflow state of 'active'" do
        assert_equal("active", @canvas_course.pages.first.workflow_state)
      end

      it "should create a canvas_cc module item and add it to the module" do
        assert(
          @canvas_module.module_items.first.is_a?(
            CanvasCc::CanvasCC::Models::ModuleItem,
          ),
        )
      end
    end

    describe "_create_canvas_file" do
      it "should return a canvas_cc file" do
        assert(
          @source_file.canvas_file.is_a?(
            CanvasCc::CanvasCC::Models::CanvasFile,
          ),
        )
      end

      it "should give the canvas_cc file an identifier" do
        refute_nil(@source_file.canvas_file.identifier)
      end

      it "should give the canvas_cc file a file location" do
        assert_equal(@file_path, @source_file.canvas_file.file_location)
      end

      it "should make the canvas_cc file visible" do
        refute(@source_file.canvas_file.hidden)
      end

      it "should give the canvas_cc file a file path" do
        assert_equal(
          File.join("Volume 2", File.basename(@file_path)),
          @source_file.canvas_file.file_path,
        )
      end
    end

    describe "_html_text" do
      it "should return HTML content" do
        assert_includes(
          @canvas_course.pages.first.body,
          "Source file converted to HTML",
        )
      end

      it "should give src attributes the correct path" do
        node_html = Nokogiri::HTML.fragment(@canvas_course.pages.first.body)

        node_html.search("img").each do |image_tag|
          assert_includes(image_tag["src"], "IMS_CC_FILEBASE")
          assert_includes(image_tag["src"], "source_file_images")
        end
      end
    end

    describe "_copy_html_images" do
      it "should add HTML images to the canvas course" do
        assert_equal(2, @canvas_course.files.size)
      end

      it "should create and populate a canvas_cc file for HTML images" do
        first_file = @canvas_course.files.first

        assert(first_file.is_a?(CanvasCc::CanvasCC::Models::CanvasFile))
        refute_nil(first_file.identifier)
        assert(first_file.hidden)
      end
    end
  end
end
