# DO NOT EDIT - This file is automatically generated
# Make changes to Manifest.txt and/or Rakefile and regenerate
# -*- encoding: utf-8 -*-
# stub: flat_kit 0.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "flat_kit".freeze
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jeremy Hinegardner".freeze]
  s.date = "2021-01-18"
  s.description = "A library and commandline program for reading, writing, indexing,  sorting, and merging CSV, TSV, JSON and other flat-file formats.".freeze
  s.email = "jeremy@copiousfreetime.org".freeze
  s.files = ["".freeze]
  s.homepage = "http://github.com/copiousfreetime/flat_kit".freeze
  s.licenses = ["https://opensource.org/licenses/MIT".freeze]
  s.rdoc_options = ["--main".freeze, "README.md".freeze, "--markup".freeze, "tomdoc".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.2.2".freeze)
  s.rubygems_version = "3.1.2".freeze
  s.summary = "A library and commandline program for reading, writing, indexing, sorting, and merging CSV, TSV, JSON and other flat-file formats.".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<rake>.freeze, ["~> 13.0"])
    s.add_development_dependency(%q<minitest>.freeze, ["~> 5.11"])
    s.add_development_dependency(%q<rdoc>.freeze, ["~> 6.3"])
    s.add_development_dependency(%q<simplecov>.freeze, ["~> 0.21"])
  else
    s.add_dependency(%q<rake>.freeze, ["~> 13.0"])
    s.add_dependency(%q<minitest>.freeze, ["~> 5.11"])
    s.add_dependency(%q<rdoc>.freeze, ["~> 6.3"])
    s.add_dependency(%q<simplecov>.freeze, ["~> 0.21"])
  end
end
