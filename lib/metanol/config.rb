require 'active_support/configurable'

module Metanol
  # Configure global settings for Metanol
  #   Metanol.configure do |config|
  #     config.verifications.google = "a7da876d8a6sd8as"
  #     config.verifications.yandex = "asdasd0a80s80asd8fsd09f8"
  #   end
  def self.configure
    yield config if block_given?
  end

  def self.config
    @config ||= Metanol::Configuration.new
  end

  class Configuration #:nodoc:
    include ActiveSupport::Configurable
    config_accessor :verifications

    def param_name
      config.param_name.respond_to?(:call) ? config.param_name.call : config.param_name
    end

    # define param_name writer (copied from AS::Configurable)
    writer, line = 'def param_name=(value); config.param_name = value; end', __LINE__
    singleton_class.class_eval writer, __FILE__, line
    class_eval writer, __FILE__, line
  end

  # this is ugly. why can't we pass the default value to config_accessor...?
  configure do |config|
    config.verifications = {}
    config.og_type = 'website'
    config.og_locale = 'uk_UA'
  end
end