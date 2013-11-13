# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'iraq_unrest/version'

Gem::Specification.new do |spec|
  spec.name          = "iraq_unrest"
  spec.version       = IraqUnrest::VERSION
  spec.authors       = ["Brian D. Smith"]
  spec.email         = ["bd9302@gmail.com"]
  spec.description   = %q{Ruby library to serialize, format, and visualize Iraq data shared by Agence France-Presse.}
  spec.summary       = %q{Generates Rickshaw/D3.js graphs and formatted data files for Iraq data}
  spec.homepage      = "https://github.com/bds/iraq_unrest"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "curb"
  spec.add_dependency "tilt"
  spec.add_dependency "active_model_serializers"
  spec.add_dependency "activesupport"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "webmock", "< 1.14" # for VCR warning
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "rake"
end
