require_relative "../helpers/spec_helper"

describe Konbata do
  describe "SourceFile" do
    before do
      @file_path = File.join("path", "to", "source_file.doc")
      volume = "2"

      @source_file = Konbata::SourceFile.new(@file_path, volume)
    end

    it "should create a canvas file on initialization" do
      canvas_file = @source_file.canvas_file

      assert_equal(
        CanvasCc::CanvasCC::Models::CanvasFile,
        canvas_file.class,
      )

      assert(canvas_file.identifier)
      assert_equal(@file_path, canvas_file.file_location)
      refute(canvas_file.hidden)

      assert_equal(
        File.join("Volume 2", File.basename(@file_path)),
        canvas_file.file_path,
      )
    end
  end
end
