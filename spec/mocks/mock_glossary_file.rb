class MockGlossaryFile < Konbata::GlossaryFile
  def _convert_to_html
    Pathname.new(fixture_path(File.join("glossary_html")))
  end
end
