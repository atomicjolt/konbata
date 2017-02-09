class MockCourse < Konbata::Course
  def _instantiate_source_files
    @volumes.each do |volume, file_paths|
      file_paths.map! do |file_path|
        if file_path[/front/i]
          MockCoverPageFile.new(file_path, volume)
        elsif file_path[/glos/i]
          MockGlossaryFile.new(file_path, volume)
        elsif file_path[/U\d+/i]
          MockUnitFile.new(file_path, volume)
        end
      end.compact!
    end
  end
end
