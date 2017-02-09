require_relative "../helpers/spec_helper"

describe Konbata do
  describe "Module" do
    describe "self.create" do
      before do
        @volume = "3"
        @module = Konbata::Module.create(@volume)
      end

      it "should return a canvas_cc module" do
        assert(@module.is_a?(CanvasCc::CanvasCC::Models::CanvasModule))
      end

      it "should give the module an identifier" do
        refute_nil(@module.identifier)
      end

      it "should give the module a title" do
        assert_equal("Volume 3", @module.title)
      end

      it "should give the module a workflow state of 'active'" do
        assert_equal("active", @module.workflow_state)
      end
    end
  end
end
