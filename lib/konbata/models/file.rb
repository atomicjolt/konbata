require "canvas_cc"
require "konbata"

module Konbata
  class SourceFile
    attr_reader :canvas_file

    def initialize(file_path, volume)
      @file_path = file_path
      @volume = volume
      @canvas_file = _create_canvas_file
    end

    private

    def _create_canvas_file
      canvas_file = CanvasCc::CanvasCC::Models::CanvasFile.new

      canvas_file.identifier = Konbata.create_random_hex
      canvas_file.file_location = @file_path
      canvas_file.hidden = false
      canvas_file.file_path = File.join(
        "Volume #{@volume}", File.basename(@file_path).to_s
      )

      canvas_file
    end
  end
end
