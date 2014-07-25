# -*- encoding: utf-8 -*-
require File.expand_path('../lib/liftapp-client/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jonathan Maddison"]
  gem.email         = ["jmaddi@gmail.com"]
  gem.description   = %q{A ruby client for the Lift.do API}
  gem.summary       = %q{Client allows you to access your Lift.do habits and checkins.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "liftapp-client"
  gem.require_paths = ["lib"]
  gem.version       = Liftapp::Client::VERSION

  gem.add_dependency 'httparty'
  gem.add_dependency 'nokogiri'
  # gem.add_dependency 'json'
  # gem.add_dependency 'date'

  gem.add_development_dependency 'webmock'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
end
