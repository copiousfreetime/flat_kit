# frozen_string_literal: true

# vim: syntax=ruby
load "tasks/this.rb"

This.name     = "flat_kit"
This.author   = "Jeremy Hinegardner"
This.email    = "jeremy@copiousfreetime.org"
This.homepage = "http://github.com/copiousfreetime/#{This.name}"

This.ruby_gemspec do |spec|
  spec.add_runtime_dependency("oj", "~> 3.0")
  spec.add_runtime_dependency("optimist", "~> 3.0")
  spec.add_runtime_dependency("csv", "~> 3.3")

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/copiousfreetime/#{This.name}/issues",
    "changelog_uri" => "https://github.com/copiousfreetime/#{This.name}/blob/master/HISTORY.md",
    "homepage_uri" => "https://github.com/copiousfreetime/#{This.name}",
    "source_code_uri" => "https://github.com/copiousfreetime/#{This.name}",
    "label" => "flat_kit",
    "rubygems_mfa_required" => "true",
  }
end

load "tasks/default.rake"
