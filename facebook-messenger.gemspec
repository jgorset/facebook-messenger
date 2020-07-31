lib = File.expand_path('lib', __dir__)
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

  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rack-test', '~> 0.6.3'
  spec.add_development_dependency 'rake', '~> 13.0.1'
  spec.add_development_dependency 'rspec', '~> 3.9'
  spec.add_development_dependency 'rubocop', '~> 0.58.1'
  spec.add_development_dependency 'webmock', '~> 3.8.1'
end
