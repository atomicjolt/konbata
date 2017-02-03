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

  [
    ["rake", "~> 11.3"],
    ["nokogiri", "~> 1.6.6"],
    ["activesupport", "~> 4.2"],
    ["canvas_cc", "~> 0.0.33"],
  ].each { |d| spec.add_runtime_dependency(*d) }
end
