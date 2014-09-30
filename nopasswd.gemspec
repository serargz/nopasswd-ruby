# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nopasswd/version'

Gem::Specification.new do |s|
  s.name        = 'nopasswd'
  s.version     = NoPasswd::VERSION
  s.authors     = ["Sergio Aristizábal"]
  s.email       = 'serargz@gmail.com'
  s.description = "A simple command line password manager"
  s.summary     = "Command line password manager"
  s.homepage    = 'http://rubygems.org/gems/nopasswd'
  s.license     = 'MIT'

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_runtime_dependency "thor"
  s.add_runtime_dependency "clipboard", "~> 1.0.5"
  s.add_runtime_dependency "dropbox-sdk"

  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "rake"
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'faker'
end
