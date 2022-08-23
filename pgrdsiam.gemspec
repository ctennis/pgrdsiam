# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "pgrdsiam/version"

Gem::Specification.new do |spec|
  spec.name          = "pgrdsiam"
  spec.version       = PGRDSIAM::VERSION
  spec.authors       = ["Caleb Tennis"]
  spec.email         = ["caleb@reverb.com"]

  spec.summary       = 'Internal PGRDSIAM gem'

  spec.metadata = {
    "github_repo" => "ssh://github.com/reverbdotcom/pgrdsiam",
    "allowed_push_host" => "https://rubygems.pkg.github.com"
  }

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "aws-sdk-rds", "~> 1.44.0"

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'pry', '~> 0.10'
  spec.add_development_dependency "webmock", '~> 3.0'
  spec.add_development_dependency "rubocop", "0.58.0"
end
