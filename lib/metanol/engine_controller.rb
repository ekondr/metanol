require 'active_support/dependencies'

module Metanol
  # Engine's controller which has all methods for storing and processing meta tag's data
  module EngineController
    extend ActiveSupport::Concern

    included do
      before_action :clear_metanols
    end

    module ClassMethods
      def common_metanols
        @@common_metanols ||= {}
      end

      SUPPORT_GROUPS.keys.each do |method|
        method_name = "#{method == :main ? '' : "#{method}_"}meta"
        define_method method_name do |*args|
          add_meta_tag(common_metanols, method, *args)
        end

        get_method_name = "get_#{method_name}"
        define_method get_method_name do |name|
          get_meta_tag(common_metanols, method, name)
        end
      end

      private

      def add_meta_tag(repo, type, *args)
        if args[0].is_a? Hash
          filters = args[1..-1]
          args[0].each do |name, value|
            add_meta_by_type repo, type, name, value, filters
          end
        else
          name = args[0].to_sym
          value = args[1]
          filters = args[2..-1]
          add_meta_by_type repo, type, name, value, filters
        end
      end

      def add_meta_by_type(repo, type, name, value, filters = [])
        meta_class = SUPPORT_GROUPS[type]
        key = get_meta_key(type, name)
        unless repo.key? key
          repo[key] = meta_class.new(name, value, filters)
          return
        end
        repo[key].value = value
        repo[key].filters = filters
      end

      def get_meta_tag(repo, type, name)
        key = get_meta_key(type, name)
        repo.key?(key) ? repo[key].value : nil
      end

      def get_meta_key(type, name)
        "#{type}:#{name}"
      end
    end

    SUPPORT_GROUPS.keys.each do |method|
      method_name = "#{method == :main ? '' : "#{method}_"}meta"
      define_method method_name do |*args|
        self.class.send 'add_meta_tag', action_metanols, method, *args
      end

      get_method_name = "get_#{method_name}"
      define_method get_method_name do |name|
        self.class.send 'get_meta_tag', action_metanols, method, name
      end
    end

    def action_metanols
      @action_metanols ||= {}
    end

    private

    def clear_metanols
      @action_metanols = {}
    end
  end
end
