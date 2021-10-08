# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'metanol/version'

Gem::Specification.new do |spec|
  spec.name = 'metanol'
  spec.version = Metanol::VERSION
  spec.authors = ['Yevhen Kondratiuk']
  spec.email = ['ekondr@gmail.com']

  spec.summary = '<META> tags engine plugin for Ruby on Rails applications'
  spec.description = 'This is a meta tags plugin which helps to manage meta tags in '\
                     'your Rails application. It supports some OpenGraph meta tags, '\
                     "Webmaster's meta tags (such as Google, Bing, Yandex, Alexa "\
                     'verification tags), MicroData meta tags and other standard '\
                     'HTML meta tags (such as a <description>, <title> etc). It can be used by '\
                     'Rails 3.2+ applications.'
  spec.homepage = 'https://github.com/ekondr/metanol'
  spec.license = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.respond_to?(:metadata) ||
    raise('RubyGems 2.0 or newer is required to protect against public gem pushes.')

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = 'bin'
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.3'

  spec.add_dependency 'rails', '>= 6.0'
  spec.add_development_dependency 'capybara', '>= 0'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rspec', '>= 3.0'
  spec.add_development_dependency 'rspec-rails', '>= 5.0'
  spec.add_development_dependency 'sqlite3', '>= 0'
end
