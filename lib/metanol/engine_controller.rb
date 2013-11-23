require File.join(File.dirname(__FILE__), 'meta/base')
require File.join(File.dirname(__FILE__), 'meta/main')
require File.join(File.dirname(__FILE__), 'meta/open_graph')
require File.join(File.dirname(__FILE__), 'meta/webmaster')
require 'active_support/dependencies'

module Metanol

  # Engine's controller which has all methods for storing and processing meta tag's data
  module EngineController
    extend ActiveSupport::Concern

    module ClassMethods
      def metanol_options
        @@metanol_options ||= {}
      end

      def meta(*args)
        add_meta_tag(:main, *args)
      end

      def og_meta(*args)
        add_meta_tag(:og, *args)
      end

      def wm_meta(*args)
        add_meta_tag(:wm, *args)
      end

      def get_meta(name)
        get_meta_by_type(:main, name)
      end

      def get_og_meta(name)
        get_meta_by_type(:og, name)
      end

      def get_wm_meta(name)
        get_meta_by_type(:wm, name)
      end

      private

      def add_meta_tag(type, *args)
        if args[0].is_a? Hash
          filters = args[1..-1]
          args[0].each do |name, value|
            add_meta_by_type type, name, value, filters
          end
        else
          name = args[0].to_sym
          value = args[1]
          filters = args[2..-1]
          add_meta_by_type type, name, value, filters
        end
      end

      def add_meta_by_type(type, name, value, filters=[])
        data = meta_data(name)[type]
        key = data[:key]
        if metanol_options.key? key
          metanol_options[key].value = value
          metanol_options[key].filters = filters
        else
          metanol_options[key] = data[:type].new(name, value, filters)
        end
      end

      def get_meta_by_type(type, name)
        data = meta_data(name)[type]
        key = data[:key]
        metanol_options.key?(key) ? metanol_options[key].value : nil
      end

      def meta_data(name)
        {
            main: { key: name, type: Meta::Main },
            og: { key: "og:#{name}", type: Meta::OpenGraph },
            wm: { key: "wm:#{name}", type: Meta::Webmaster }
        }
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

    def get_meta(name)
      self.class.get_meta name
    end

    def get_og_meta(name)
      self.class.get_og_meta name
    end

    def get_wm_meta(name)
      self.class.get_wm_meta name
    end

  end

end