require File.join(File.dirname(__FILE__), 'meta/base')
require File.join(File.dirname(__FILE__), 'meta/main')
require File.join(File.dirname(__FILE__), 'meta/open_graph')
require File.join(File.dirname(__FILE__), 'meta/webmaster')
require 'active_support/dependencies'

module Metanol

  # Engine's controller which has all methods for storing and processing meta tag's data
  # todo: to refactor the class!
  module EngineController
    extend ActiveSupport::Concern

    module ClassMethods

      def metanol_options
        @metanol_options ||= {}
      end

      def meta(*args)
        add_meta_tag(*args) do |name, value|
          add_main_meta name, value
        end
      end

      def og_meta(*args)
        add_meta_tag(*args) do |name, value|
          add_og_meta name, value
        end
      end

      def wm_meta(*args)
        add_meta_tag(*args) do |name, value|
          add_wm_meta name, value
        end
      end

      private

      def add_meta_tag(*args)
        if args[0].is_a? Hash
          args[0].each do |name, value|
            yield name, value
          end
        elsif args.length == 2
          name = args[0].to_sym
          value = args[1].to_sym
          yield name, value
        end
      end

      def add_main_meta(name, value)
        if metanol_options.key? name
          metanol_options[name].value = value
        else
          metanol_options[name] = Meta::Main.new(name, value)
        end
      end

      def add_og_meta(name, value)
        key = "og:#{name}".to_sym
        if metanol_options.key? key
          metanol_options[key].value = value
        else
          metanol_options[key] = Meta::OpenGraph.new(name, value)
        end
      end

      def add_wm_meta(name, value)
        key = "wm:#{name}".to_sym
        if metanol_options.key? key
          metanol_options[key].value = value
        else
          metanol_options[key] = Meta::Webmaster.new(name, value)
        end
      end

    end

    def meta(*args)
      self.class.meta(*args)
    end

    def og_meta(*args)
      self.class.og_meta(*args)
    end

    def wm_meta(*args)
      self.class.wm_meta(*args)
    end

    def metanol_options
      self.class.metanol_options
    end

  end

end