# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scheduled_resource/version'

Gem::Specification.new do |spec|
  spec.name          = "scheduled_resource"
  spec.version       = ScheduledResource::VERSION
  spec.authors       = ["Mike Cannon"]
  spec.email         = ["michael.j.cannon@gmail.com"]
  spec.summary       = %q{Display how something is used over time.}
  spec.description   = %Q{== README.md:\n#{IO.read 'README.md'}}
  spec.homepage      = "http://github.com/emeyekayee/scheduled_resource"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", "~> 4.2"
  spec.add_dependency "coffee-rails", "~> 4.1"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
