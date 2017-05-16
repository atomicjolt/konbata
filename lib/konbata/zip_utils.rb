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

require "konbata/error_logger"

module Konbata
  module ZipUtils
    ##
    # Finds and returns any PDF files in the zip file as a list of filepaths.
    ##
    def self.pdfs(zip_path)
      pdf_entries = Zip::File.new(zip_path).entries.select do |entry|
        File.extname(entry.name) =~ /\.pdf/i
      end

      pdf_entries.map(&:name)
    end

    ##
    # Extracts the list of files from the zip file to the output directory
    # and returns a nested list of the file names and extracted locations.
    ##
    def self.extract_files(zip_path, files, output_dir = Dir.mktmpdir)
      zip = Zip::File.new(zip_path)

      files.map do |file|
        entry = zip.find_entry(file)

        if entry
          extract_to = File.join(output_dir, file)

          unless File.exist?(extract_to)
            FileUtils.mkdir_p(File.join(output_dir, File.dirname(file)))
            entry.extract(extract_to)
          end

          [extract_to, file]
        else
          ErrorLogger.log_missing_file(file, zip_path)
          next
        end
      end.compact
    end
  end
end
