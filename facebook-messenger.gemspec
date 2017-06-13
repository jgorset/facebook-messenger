# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'facebook/messenger/version'

Gem::Specification.new do |spec|
  spec.name          = 'facebook-messenger'
  spec.version       = Facebook::Messenger::VERSION
  spec.authors       = ['Johannes Gorset']
  spec.email         = ['jgorset@gmail.com']

  spec.summary       = 'Facebook Messenger client'
  spec.description   = 'Facebook Messenger client'
  spec.homepage      = 'https://github.com/hyperoslo/facebook-messenger'
  spec.license       = 'MIT'

  spec.files         = Dir[
    '{lib,test,bin,doc,config}/**/*', 'LICENSE', 'README*'
  ]

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'httparty', '~> 0.13', '>= 0.13.7'
  spec.add_runtime_dependency 'rack', '>= 1.4.5'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'rack-test', '~> 0.6.3'
  spec.add_development_dependency 'rubocop', '~> 0.48.1'
  spec.add_development_dependency 'webmock', '~> 1.24'
  spec.add_development_dependency 'rake', '~> 11.0'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'pry'
end
