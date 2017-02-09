require "canvas_cc"
require "libreconv"
require "konbata/models/module_item"

module Konbata
  class SourceFile
    attr_reader :canvas_file

    def initialize(file_path, volume)
      @file_path = file_path
      @volume = volume
      @canvas_file = _create_canvas_file
      @html = _to_html
      # @title may be overwritten by subclass.
      @title = File.basename(file_path).
        sub(/\.docx?$/i, ""). # Remove .doc or .docx file extension.
        sub(/\(\d{1,2}\)/, ""). # Remove (1), (2), etc. in file name.
        strip
    end

    def convert(canvas_course, canvas_module)
      page = CanvasCc::CanvasCC::Models::Page.new
      page.identifier = Konbata.create_random_hex
      page.workflow_state = "active"
      page.page_name = @title
      page.body = @html

      module_item = Konbata::ModuleItem.create(
        @title,
        page.identifier,
      )

      canvas_module.module_items << module_item
      canvas_course.pages << page
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
