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
  resources :home
end

class ApplicationController < ActionController::Base; end

class HomeController < ApplicationController
  og_meta :type,    'website'
  og_meta :locale,  'uk_UA'

  wm_meta :alexa,   'alexa code'
  wm_meta :bing,    'bing code'
  wm_meta :google,  'google code'
  wm_meta :yandex,  'yandex code'

  def new
    render :inline => <<-ERB
      <%= metanol_wm_tags %>
    ERB
  end

  def index
    og_meta title: "OpenGraph Title", description: "OpenGraph Description"
    render :inline => <<-ERB
      <%= metanol_tags %>
    ERB
  end
end

Object.const_set(:ApplicationHelper, Module.new)