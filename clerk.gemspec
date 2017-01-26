# -*- encoding: utf-8 -*-
require File.expand_path('../lib/clerk/version', __FILE__)

Gem::Specification.new do |gem|

  summary = %q{
    For Rails applications - add creator and updater to your ActiveRecord models
    and automatically set these from current_user
  }

  gem.authors       = ["Jesse House"]
  gem.email         = ["jesse.house@gmail.com"]
  gem.description   = "#{summary}\nSee the README on github for more info"
  gem.summary       = summary
  gem.homepage      = "https://github.com/house9/clerk"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "clerk"
  gem.require_paths = ["lib"]
  gem.version       = Clerk::VERSION
  gem.licenses      = ['MIT']

  gem.add_dependency 'activerecord', '> 5'
  gem.add_dependency 'railties', '> 3.1'
  gem.add_dependency 'sentient_user', '>= 0.4.0'


  gem.add_development_dependency 'bundler', '>= 1.1.3'
  gem.add_development_dependency 'rspec', '~> 2.9.0'

  if defined?(JRUBY_VERSION)
    gem.add_development_dependency 'activerecord-jdbcsqlite3-adapter'
    gem.add_development_dependency 'jruby-openssl'
  else
    gem.add_development_dependency 'sqlite3'
  end
end
