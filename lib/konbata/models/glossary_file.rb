require "libreconv"

module Konbata
  class GlossaryFile < Konbata::SourceFile
    def convert(canvas_course)
      page = CanvasCc::CanvasCC::Models::Page.new
      page.identifier = Konbata.create_random_hex
      page.workflow_state = "active"
      page.page_name = "Glossary"
      page.body = @html

      canvas_course.pages << page
    end
  end
end
