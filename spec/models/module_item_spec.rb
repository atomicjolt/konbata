require_relative "../helpers/spec_helper"

describe Konbata do
  describe "SourceFile" do
    describe "self.create" do
      before do
        @title = "Test Module Item"
        @identifierref = Konbata.create_random_hex
        @module_item = Konbata::ModuleItem.create(@title, @identifierref)
      end

      it "should return a canvas_cc module item" do
        assert(@module_item.is_a?(CanvasCc::CanvasCC::Models::ModuleItem))
      end

      it "should give the module item a title" do
        assert_equal(@title, @module_item.title)
      end

      it "should give the module item an identifier" do
        refute_nil(@module_item.identifier)
      end

      it "should give the module item a content type of 'WikiPage'" do
        assert_equal("WikiPage", @module_item.content_type)
      end

      it "should give the module item an identifierref" do
        assert_equal(@identifierref, @module_item.identifierref)
      end

      it "should give the module item a workflow state of 'acvive'" do
        assert_equal("active", @module_item.workflow_state)
      end
    end
  end
end
