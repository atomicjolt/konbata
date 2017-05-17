# Copyright (C) 2017  Atomic Jolt
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require_relative "helpers/spec_helper"
require "konbata/zip_utils"

describe Konbata::ZipUtils do
  before do
    @zip_file_path = fixture_path("zipped_pdfs.zip")
  end

  describe ".pdfs" do
    it "returns a list of all PDFs in the zip file" do
      assert_equal(
        %w{zipped_pdfs/pdf1.pdf zipped_pdfs/pdf2.pdf zipped_pdfs/pdf3.pdf},
        Konbata::ZipUtils.pdfs(@zip_file_path),
      )
    end
  end

  describe ".extract_files" do
    before do
      @temp_dir = Dir.mktmpdir

      @file_one = "zipped_pdfs/pdf1.pdf"
      @file_two = "zipped_pdfs/pdf2.pdf"
      @fake_file = "zipped_pdfs/im-not-real.pdf"
    end

    it "extracts the files passed to it" do
      Konbata::ZipUtils.extract_files(@zip_file_path, [@file_one], @temp_dir)

      assert(File.exist?(File.join(@temp_dir, @file_one)))
    end

    it "returns a list of tuples of the extracted and original filepaths" do
      results = Konbata::ZipUtils.extract_files(
        @zip_file_path,
        [@file_one],
        @temp_dir,
      )

      expected_results = [[File.join(@temp_dir, @file_one), @file_one]]

      assert_equal(expected_results, results)
    end

    it "doesn't throw an error if a file given doesn't exist in the zip" do
      ErrorLogger.stub(:log, nil) do
        files = [@file_one, @fake_file]

        Konbata::ZipUtils.extract_files(@zip_file_path, files, @temp_dir)
      end
    end

    it "doesn't return a nonexistent file in the result list" do
      ErrorLogger.stub(:log, nil) do
        results = Konbata::ZipUtils.extract_files(
          @zip_file_path,
          [@file_one, @fake_file],
          @temp_dir,
        )

        expected_results = [[File.join(@temp_dir, @file_one), @file_one]]

        assert_equal(expected_results, results)
      end
    end

    it "doesn't throw an error if given duplicate files" do
      Konbata::ZipUtils.extract_files(
        @zip_file_path,
        [@file_one, @file_two],
        @temp_dir,
      )
    end
  end
end
