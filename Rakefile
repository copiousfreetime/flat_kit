# vim: syntax=ruby
load 'tasks/this.rb'

This.name     = "flat_kit"
This.author   = "Jeremy Hinegardner"
This.email    = "jeremy@copiousfreetime.org"
This.homepage = "http://github.com/copiousfreetime/#{ This.name }"

This.ruby_gemspec do |spec|
  spec.add_dependency('optimist', '~> 3.0')

  spec.add_development_dependency( 'rake'     , '~> 13.0')
  spec.add_development_dependency( 'minitest' , '~> 5.11' )
  spec.add_development_dependency( 'rdoc'     , '~> 6.3' )
  spec.add_development_dependency( 'simplecov', '~> 0.21')
end

load 'tasks/default.rake'
