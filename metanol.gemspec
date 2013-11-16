# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'metanol/version'

Gem::Specification.new do |gem|
  gem.name          = "metanol"
  gem.version       = Metanol::VERSION
  gem.platform        = Gem::Platform::RUBY
  gem.authors       = ["Eugene Kondratyuk"]
  gem.email         = ["ekondr@gmail.com"]
  gem.description   = %q{This is a meta tags plugin which helps to manage meta tags in your Rails application. It supports some OpenGraph meta tags, Webmaster's meta tags (such as Google, Bing, Yandex, Alexa verification meta tags) and other standard HTML meta tags (such as a description). It can be used by Rails 3.2+ applications}
  gem.summary       = %q{A meta tags engine plugin for Rails 3.2+ applications}
  gem.homepage      = "https://github.com/ekondr/metanol"

  gem.rubyforge_project = 'metanol'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.licenses = ['MIT']

  gem.add_dependency "rails", "~> 3.2"
end
