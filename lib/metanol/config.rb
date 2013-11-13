require 'active_support/configurable'

module Metanol
  # Configure global settings for Metanol
  #   Metanol.configure do |config|
  #     config.og_type = "website"
  #     config.og_locale = "uk_UA"
  #     config.verification.google = "a7da876d8a6sd8as"
  #     config.verification.yandex = "asdasd0a80s80asd8fsd09f8"
  #   end
  def self.configure
    yield config if block_given?
  end

  def self.config
    @config ||= Configuration.new
  end

  class Configuration #:nodoc:
    include ActiveSupport::Configurable
    config_accessor :verification
    config_accessor :og_type
    config_accessor :og_locale

    def initialize
      super
      self.verification = ::Metanol::Verification.new
    end
  end

  class Verification #:nodoc:
    include ActiveSupport::Configurable
    config_accessor :bing
    config_accessor :google
    config_accessor :yandex
  end
end