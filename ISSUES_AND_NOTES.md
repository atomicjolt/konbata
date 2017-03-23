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

## Issues:

- You can’t name files the same thing even if they're in separate modules. There will be name collisions. Or maybe you can’t name module items the same thing. All the files will end up in the file tree, but there will be missing module items. Right now, we're appending “(Vol. <volume>)” to every filename to fix the problem. There's probably a better way though.

- We don't handle errors resulting from an incomplete or badly formed konbata.yml file.
