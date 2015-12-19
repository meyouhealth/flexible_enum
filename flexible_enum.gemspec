# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'flexible_enum/version'

Gem::Specification.new do |spec|
  spec.name          = "flexible_enum"
  spec.version       = FlexibleEnum::VERSION

  contributors       = `git shortlog -sne`.split("\n").collect { |l| l.scan(/\t(.*) <(.*)>/) }.flatten(1)
  spec.authors       = contributors.collect(&:first)
  spec.email         = contributors.collect(&:last)

  spec.description   = %q{Helpers for enum-like fields}
  spec.summary       = %q{Helpers for enum-like fields}
  spec.homepage      = "https://github.com/meyouhealth/flexible_enum"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", ">= 4.1"

  spec.add_development_dependency "activerecord"
  spec.add_development_dependency "appraisal"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "fury"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "sqlite3"
end
