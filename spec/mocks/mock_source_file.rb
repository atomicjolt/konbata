class MockSourceFile < Konbata::SourceFile
  def _convert_to_html
    Pathname.new(fixture_path(File.join("source_file_html")))
  end
end
