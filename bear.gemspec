# -*- encoding: utf-8 -*-
require File.expand_path("../lib/bear/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "bear"
  s.version     = Bear::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Russ Smith"]
  s.email       = ["russ@bashme.org"]
  s.homepage    = "http://github.com/russ/bear"
  s.summary     = "bear-#{s.version}"
  s.description = "Generate a Rails 3 app with application templates."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "bear"

  s.add_dependency "thor"
  s.add_dependency('rails', '>= 3.0.0')
  s.add_development_dependency "bundler", "~> 1.0.0"
  s.add_development_dependency "cucumber"
  s.add_development_dependency "aruba" 
  s.add_development_dependency "rspec", "~> 2.0.0"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
