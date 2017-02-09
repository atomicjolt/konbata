require "konbata/models/source_file"

module Konbata
  class GlossaryFile < Konbata::SourceFile
    def initialize(file_path, volume)
      super
      @title = "Glossary (Vol. #{volume})"
    end
  end
end