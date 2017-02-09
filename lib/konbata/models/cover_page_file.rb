require "konbata/models/source_file"

module Konbata
  class CoverPageFile < Konbata::SourceFile
    def initialize(file_path, volume)
      super
      @title = "Course Info (Vol. #{volume})"
    end
  end
end
