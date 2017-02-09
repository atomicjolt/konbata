require "minitest/autorun"
require "minitest/reporters"
Minitest::Reporters.use!

require "konbata"
require_relative "../mocks/mock_course"
require_relative "../mocks/mock_cover_page_file"
require_relative "../mocks/mock_glossary_file"
require_relative "../mocks/mock_source_file"
require_relative "../mocks/mock_unit_file"

def fixture_path(fixture)
  File.absolute_path(File.join("spec", "fixtures", fixture))
end
