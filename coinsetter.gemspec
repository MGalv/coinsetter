# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'coinsetter/version'

Gem::Specification.new do |spec|
  spec.name          = "coinsetter"
  spec.version       = Coinsetter::VERSION
  spec.authors       = ["Luis Galaviz"]
  spec.email         = ["galaviz.lm@gmail.com"]
  spec.summary       = %q{Simple API connection to Coinsetter.}
  spec.description   = %q{Simple API connection to Coinsetter.}
  spec.homepage      = "https://github.com/MGalv/coinsetter"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"

  spec.add_runtime_dependency('activemodel', ['>= 4.1'])
  spec.add_runtime_dependency('activesupport', ['>= 4.1'])
  spec.add_runtime_dependency('rest_client', ['= 1.7.3'])
end
