# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bbs_2ch_url_validator/version'

Gem::Specification.new do |spec|
  spec.name          = 'bbs_2ch_url_validator'
  spec.version       = Bbs2chUrlValidator::VERSION
  spec.authors       = ['dogwood008']
  spec.email         = ['dogwood008+github@gmail.com']

  spec.summary       = 'This is a validator for 2ch URL.'
  spec.description   = spec.summary
  spec.homepage      = 'http://github.com/dogwood008/bbs_2ch_url_validator'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'shoulda-matchers', '~> 3.1'
  spec.add_development_dependency 'rspec-its', '~> 1.2'
end
