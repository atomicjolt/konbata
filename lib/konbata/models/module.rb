require "canvas_cc"

module Konbata
  class Module
    def self.create(volume)
      canvas_module = CanvasCc::CanvasCC::Models::CanvasModule.new
      canvas_module.identifier = Konbata.create_random_hex
      canvas_module.title = "Volume #{volume}"
      canvas_module.workflow_state = "active"

      canvas_module
    end
  end
end
