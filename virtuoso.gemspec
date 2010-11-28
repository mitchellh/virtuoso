# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "virtuoso/version"

Gem::Specification.new do |s|
  s.name        = "virtuoso"
  s.version     = Virtuoso::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Mitchell Hashimoto"]
  s.email       = ["mitchell.hashimoto@gmail.com"]
  s.homepage    = "http://rubygems.org/gems/virtuoso"
  s.summary     = "Dead simple virtual machine management via many hypervisors."
  s.description = "Dead simple virtual machine management via many hypervisors."

  s.rubyforge_project = "virtuoso"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
