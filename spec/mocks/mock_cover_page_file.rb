class MockCoverPageFile < Konbata::CoverPageFile
  def _convert_to_html
    Pathname.new(fixture_path(File.join("cover_page_html")))
  end
end
