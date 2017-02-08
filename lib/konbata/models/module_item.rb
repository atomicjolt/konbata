module Konbata
  class ModuleItem
    def self.create(title, identifierref)
      module_item = CanvasCc::CanvasCC::Models::ModuleItem.new
      module_item.title = title
      module_item.identifier = Konbata.create_random_hex
      module_item.content_type = "WikiPage"
      module_item.identifierref = identifierref
      module_item.workflow_state = "active"

      module_item
    end
  end
end
