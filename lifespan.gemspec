# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lifespan/version'

Gem::Specification.new do |spec|
  spec.name          = "lifespan"
  spec.version       = Lifespan::VERSION
  spec.authors       = ["Gen Takahashi"]
  spec.email         = ["gendosu@gmail.com"]

  spec.summary       = "provides filtering of data at the start_at and end_at"
  spec.description   = "provides filtering of data at the start_at and end_at"
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

unless ENV['TRAVIS']
  spec.add_runtime_dependency "activerecord",  ">= 4.0.0", "< 5.0"
  spec.add_runtime_dependency "activesuport",  ">= 4.0.0", "< 5.0"
end

  spec.add_development_dependency "bundler"#, "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_development_dependency "rspec", "~> 3.1.0"
  spec.add_development_dependency "mysql2"
  spec.add_development_dependency "factory_girl", "~> 4.4.0"
  spec.add_development_dependency "delorean"
end
