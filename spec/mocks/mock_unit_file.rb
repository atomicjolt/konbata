class MockUnitFile < Konbata::UnitFile
  def _convert_to_html
    Pathname.new(fixture_path(File.join("unit_html")))
  end
end
