class MockCourse < Konbata::Course
  def _create_source_files
    source_files = []

    @volumes.each do |volume, file_paths|
      file_paths.each do |file_path|
        if file_path[/glos/i]
          source_files << MockGlossaryFile.new(file_path, volume)
        else
          source_files << MockSourceFile.new(file_path, volume)
        end
      end
    end

    source_files
  end
end
