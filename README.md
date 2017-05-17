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

Konbata converts SCORM packages and zipped PDFs into Canvas courses. It can generate an .imscc file and also upload that .imscc to create a course in a Canvas instance.

## Installation

After checking out the repo, run `bundle install` to install dependencies.

Create a `konbata.yml` file and add credentials for uploading to Canvas:
```yaml
# e.g. http://<canvas-url>/api
:canvas_url: <canvas instance api url>

# Found in Account >> Profile >> Generate Access Token
:canvas_token: <canvas token>

# ID found at specific course url: http://<canvas-url>/accounts/_ID_
# This can be :self, :default, or an ID.
:account_id: <account id>

:scorm_url: <scorm manager url>
:scorm_launch_url: <scorm launch url>
:scorm_shared_auth: <scorm manager token>

# Leave empty for DEFAULT_TIMEOUT
:request_timeout: <request timeout seconds>
```

## Usage

Any `.zip` files placed at the top level of the `sources` directory will be processed.

Konbata is designed to process two types of SCORM packages (interactive and non-interactive) along with zip archives containing PDF files.

Below is a breakdown of how each type is handled.

_For Interactive SCORM Packages_
- During .imscc Creation
  - Create a Canvas course.
  - Add the original SCORM package to the Files section in Canvas.
  - Add any PDF files from the SCORM package to the Files section.
  - Add any images from the SCORM package to Files section.
  - Set default view to “Assignments”.
- During Upload
  - Add the SCORM package to the SCORM player.
  - Create an assignment for the SCORM package.
  - For students, hide all tabs except "Home" and "Assignments".

_For Non-Interactive SCORM Packages_
- During .imscc Creation
  - Create a Canvas course.
  - Add the original SCORM package to the Files section in Canvas.
  - Add any PDF files from the SCORM package to the Files section.
  - Add any images from the SCORM package to Files section.
  - Create a Canvas page for each primary PDF file.
  - Add all Canvas pages to a module.
  - Set the default view to “Modules”
- During Upload
  - Add the SCORM package to the SCORM player.
  - For students, hide all tabs except "Home" and "Modules".

_For Zipped PDFs_
- During .imscc Creation
  - Create a Canvas course.
  - Add all PDFs to the Files section in Canvas.
  - Create a module item for each PDF file.
  - Add all module items to a module.
  - Set the default view to “Modules”
- During Upload
  - For students, hide all tabs except "Home" and "Modules".

#### Running

To run Konbata, use the following Rake tasks:

Convert files:
```bash
rake konbata:convert[interactive]
# or
rake konbata:convert[non_interactive]
# or
rake konbata:convert[pdfs]
```

Upload to Canvas:
```bash
rake konbata:upload[interactive]
# or
rake konbata:upload[non_interactive]
# or
rake konbata:upload[pdfs]
```

Delete the entire output folder and log folder:
```bash
rake konbata:clean
```

Note: If you are using Zsh as your shell, you will probably need to escape brackets when running these Rake tasks. e.g. `rake konbata:upload\[interactive\]` or `rake 'konbata:upload[interactive]'`. Check [this article](https://robots.thoughtbot.com/how-to-use-arguments-in-a-rake-task) for more details.

#### Errors

If there are errors during processing, an error log is generated and added to the `/log` directory. It logs errors related to when a file is referenced inside the SCORM package manifest but said file doesn't actually exist inside the package or when Konbata expects a certain file in order to generate content but it can't find the file.

## License

The gem is available as open source under the terms of the [AGPL 3.0 License](http://www.gnu.org/licenses/).
