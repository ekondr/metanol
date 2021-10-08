# frozen_string_literal: true

require 'action_controller/railtie'
require 'action_view/railtie'
require 'active_record/railtie' if defined? ActiveRecord

# Application Config
class MetanolTestApp < Rails::Application
  config.secret_key_base = config.secret_token = 'f974ebb750a8e200c85f7a749d589fa2'
  config.session_store :cookie_store, key: '_myapp_session'
  config.active_support.deprecation = :log
  config.eager_load = false

  config.root = File.dirname(__FILE__)
end
Rails.backtrace_cleaner.remove_silencers!
Rails.application.initialize!

# Routes config
Rails.application.routes.draw do
  resources :tests
  resources :home do
    collection do
      get :show_title
    end
  end
end

# Controllers
class ApplicationController < ActionController::Base; end

class ParentController < ApplicationController
  wm_meta :alexa, 'alexa code'
  wm_meta :yandex, 'yandex code'
  wm_meta bing: 'bing code', google: 'google code'
end

class HomeController < ParentController
  og_meta :type,    'website'
  og_meta :locale,  'uk_UA'

  def new
    render inline: <<-ERB
      <%= metanol_wm_tags %>
    ERB
  end

  def index
    meta :title, 'Index Page'
    og_meta title: 'OpenGraph Title', description: 'OpenGraph Description'
    render inline: <<-ERB
      <%= metanol_tags %>
    ERB
  end

  def show_title
    render inline: <<-ERB
      <%= metanol_main_tags %>
    ERB
  end
end

# Helpers
Object.const_set(:ApplicationHelper, Module.new)
