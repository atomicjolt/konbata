require "konbata/models/source_file"

module Konbata
  class UnitFile < Konbata::SourceFile
    def initialize(file_path, volume)
      super
      unit = @title[/U(\d+)/i, 1]
      @title = "Unit #{unit} (Vol. #{volume})"
    end
  end
end
