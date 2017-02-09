require_relative "helpers/spec_helper"

describe Konbata do
  it "should have a configuration" do
    refute_nil(Konbata.configuration)
  end
end
