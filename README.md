<!-- Copyright (C) 2017  Atomic Jolt

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>. -->

# Konbata Converter

Konbata converts .doc and .docx files into Canvas .imscc packages.

## Installation

Konbata depends on LibreOffice for source file conversion. You'll need to download and install it to your machine. You can do so [here](https://www.libreoffice.org/download/download/). Konbata was tested against LibreOffice version 5.3.0.

After checking out the repo, run `bundle install` to install dependencies.

Create a `konbata.yml` file and add credentials:
```yaml
# --LibreOffice setup--

# Generally looks like /Applications/LibreOffice.app/Contents/MacOS/soffice
:libre_office_path: <LibreOffice Path>

# --Canvas upload setup--

# e.g. http://<canvas-url>/api
:canvas_url: <canvas instance api url>

# Found in Account >> Profile >> Generate Access Token
:canvas_token: <canvas token>

# ID found at specific course url: http://<canvas-url>/accounts/_HERE_
# This can be :self, :default, or an ID.
:account_id: <account id>

# Leave empty for DEFAULT_TIMEOUT
:request_timeout: <request timeout seconds>
```

## Usage

#### Source Files
Add any files you want to process into the `sources` directory inside the Konbata project directory. It expects a specific directory structure for the source files that are added to that `sources` folder.

Each directory placed in the `sources` folder should include in it's name 2 pieces of data:
  - "Course - ####," (e.g. "Course - ABC123"). "####" will be used recognized as a course identifier.
  - "Volume " followed by a volume number (e.g. "Volume 1"). The number will be recognized as a volume number.

Each course detected will be turned into a separate .imscc file.

Each volume detected will be turned into a Canvas module inside of the appropriate course's .imscc file.

For each directory placed in the `sources` folder, Konbata will iterate through all files (though not recursively) and look for any files that match the following patterns:
```ruby
/front/i
/glos/i
/u\d+/i
```

For each file found that matches one of the above patterns, Konbata will generate an appropriately named Canvas page and add it to the appropriate ouput .imscc file.

Along with generating Canvas pages, the original source files will be added to the Canvas course's files and will be available in the Files section.

Do not place files at the top level inside the `sources` directory or Konbata will not complete processing.

#### Running

To run Konbata, use the following Rake tasks:

Convert files:
```sh
rake konbata:imscc
```

Delete the entire output folder:
```sh
rake konbata:clean
```

Upload to Canvas:
```sh
rake konbata:upload
```

## License

The gem is available as open source under the terms of the [AGPL 3.0 License](http://www.gnu.org/licenses/).
