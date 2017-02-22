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

# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "konbata/version"

Gem::Specification.new do |spec|
  spec.name          = "konbata"
  spec.version       = Konbata::VERSION
  spec.date        	 = Time.new.strftime("%Y-%m-%d")
  spec.authors       = "Atomic Jolt"

  spec.summary       = "Converts Word doc course content to Canvas courses."
  spec.description   = "Converts Word doc course content to Canvas courses."
  spec.homepage      = "http://www.atomicjolt.com/konbata"
  spec.license       = "AGPL-3.0"
  spec.extra_rdoc_files = ["README.md"]

  spec.required_ruby_version = ">= 2.0"

  spec.files = Dir["LICENSE.txt", "README.md", "lib/**/*", "bin/*"]
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }

  spec.add_development_dependency "pry-byebug", "~> 3.4"
  spec.add_development_dependency "minitest", "~> 5.9"
  spec.add_development_dependency "minitest-reporters", "~> 1.1"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-minitest"
  spec.add_development_dependency "guard-rubocop"

  [
    ["rake", "~> 11.3"],
    ["nokogiri", "~> 1.6.6"],
    ["activesupport", "~> 4.2"],
    ["pandarus", "~> 0.6.8"],
    ["rubyzip", "~> 1.2.1"],
    ["rest-client", "~> 2.0"],
  ].each { |d| spec.add_runtime_dependency(*d) }
end
