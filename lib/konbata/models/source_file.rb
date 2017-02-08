require "canvas_cc"

module Konbata
  class SourceFile
    attr_reader :canvas_file

    def initialize(file_path, volume)
      @file_path = file_path
      @volume = volume
      @canvas_file = _create_canvas_file
      @html = _to_html
    end

    def convert(convas_course)
      # TODO: Remove this noop once subclasses all have this defined.
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

    def _to_html
      output_dir = Dir.mktmpdir

      Libreconv.convert(
        @file_path,
        output_dir,
        Konbata.configuration.libre_office_path,
        "html",
      )

      html_file_name = Dir.new(output_dir).detect { |file| file[/\.html$/i] }
      html_file_path = File.join(output_dir, html_file_name)
      File.open(html_file_path, "r", &:read)
    end
  end
end
