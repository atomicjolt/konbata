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

Konbata converts SCORM packages into Canvas courses. It can generate a .imscc file and also create a Canvas course in a Canvas instance.

## Installation

After checking out the repo, run `bundle install` to install dependencies.

Create a `konbata.yml` file and add credentials for uploading to Canvas:
```yaml
# e.g. http://<canvas-url>/api
:canvas_url: <canvas instance api url>

# Found in Account >> Profile >> Generate Access Token
:canvas_token: <canvas token>

# ID found at specific course url: http://<canvas-url>/accounts/_HERE_
# This can be :self, :default, or an ID.
:account_id: <account id>

:scorm_url: <scorm manager url>
:scorm_launch_url: <scorm launch url>
:scorm_shared_auth: <scorm manager token>

# Leave empty for DEFAULT_TIMEOUT
:request_timeout: <request timeout seconds>
```

## Usage

Any `.zip` files placed at the top level of the `sources` directory will be processed as SCORM packages.

Only basic support for SCORM packages is available as of right now. For each SCORM zip found, Konbata will create a skeleton Canvas course and create an .imscc file for that course. It will add the original SCORM package to the course's files and, when running the `upload` command, Konbata will also make the appropriate calls to upload the SCORM package to the SCORM manager designated in the `konbata.yml` file.

Konbata also adds any PDF files found in the SCORM package to the course's files.

#### Running

To run Konbata, use the following Rake tasks:

Convert files:
```sh
rake konbata:scorm # For processing SCORM packages.
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
