#require 'rails/all'
require 'action_controller/railtie'
require 'action_view/railtie'
require 'active_record'

ActiveRecord::Base.configurations = {'test' => {:adapter => 'sqlite3', :database => ':memory:'}}
ActiveRecord::Base.establish_connection('test')

app = Class.new(Rails::Application)
app.config.secret_token = "f974ebb750a8e200c85f7a749d589fa2"
app.config.session_store :cookie_store, :key => "_myapp_session"
app.config.active_support.deprecation = :log
app.config.eager_load = false
app.config.root = File.dirname(__FILE__)
Rails.backtrace_cleaner.remove_silencers!
app.initialize!

app.routes.draw do
  resources :tests
end

class ApplicationController < ActionController::Base; end

Object.const_set(:ApplicationHelper, Module.new)