# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'facebook/messenger/version'

Gem::Specification.new do |spec|
  spec.name          = "facebook-messenger"
  spec.version       = Facebook::Messenger::VERSION
  spec.authors       = ["Johannes Gorset"]
  spec.email         = ["jgorset@gmail.com"]

  spec.summary       = %q{Facebook Messenger client}
  spec.description   = %q{Facebook Messenger client}
  spec.homepage      = "https://github.com/hyperoslo/facebook-messenger"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
end
