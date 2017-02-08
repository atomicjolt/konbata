require_relative "../helpers/spec_helper"

describe Konbata do
  describe "SourceFile" do
    before do
      @file_path = fixture_path("front.doc")
      volume = "2"

      @source_file = MockSourceFile.new(@file_path, volume)
    end

    it "should create a canvas_cc file on initialization" do
      assert_equal(
        CanvasCc::CanvasCC::Models::CanvasFile,
        @source_file.canvas_file.class,
      )
    end

    it "should give the canvas_cc file an identifier" do
      assert(@source_file.canvas_file.identifier)
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
end
