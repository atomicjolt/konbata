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

Konbata is designed to process two types of SCORM packages: interactive and non-interactive.

Below is a breakdown of how each type is handled.

_For Both Package Types_
- During .imscc Creation
  - Create a Canvas course.
  - Add the original SCORM package to the Files section in Canvas.
  - Add any PDF files from the SCORM package to the Files section.
  - Add any images from the SCORM package to Files section.
- During Upload
  - For students, hide all tabs except "Home" (and "Assignments" or "Modules")
  - Add the SCORM package to the SCORM player.

_For Interactive Packages_
- During .imscc Creation
  - Set default view to “Assignments”.
- During Upload
  - Create an assignment for the SCORM package.
  - For students, show the “Assignments” tab.

_For Non-Interactive Packages_
- During .imscc Creation
  - Create a Canvas page for each primary PDF file.
  - Add all Canvas pages to a module.
  - Set the default view to “Modules”
- During Upload
  - For students, show “Modules” tab.

#### Running

To run Konbata, use the following Rake tasks:

Convert files:
```bash
rake konbata:scorm[interactive]
# or
rake konbata:scorm[non_interactive]
```

Upload to Canvas:
```bash
rake konbata:upload[interactive]
# or
rake konbata:upload[non_interactive]
```

Delete the entire output folder:
```bash
rake konbata:clean
```

Note: If you are using Zsh as your shell, you will probably need to escape brackets when running these Rake tasks. e.g. `rake konbata:upload\[interactive]\]` or `rake 'konbata:upload[interactive]'`. Check [this article](https://robots.thoughtbot.com/how-to-use-arguments-in-a-rake-task) for more details.

## License

The gem is available as open source under the terms of the [AGPL 3.0 License](http://www.gnu.org/licenses/).
