require 'active_support/dependencies'

module Metanol

  # Engine's controller which has all methods for storing and processing meta tag's data
  module EngineController
    extend ActiveSupport::Concern

    module ClassMethods
      def metanol_options
        @@metanol_options ||= {}
      end

      SUPPORT_GROUPS.keys.each do |method|
        method_name = "#{method == :main ? '' : "#{method}_"}meta"
        define_method method_name do |*args|
          add_meta_tag(method, *args)
        end

        get_method_name = "get_#{method_name}"
        define_method get_method_name do |name|
          get_meta_by_type(method, name)
        end
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
        meta_class = SUPPORT_GROUPS[type]
        key = get_meta_key(type, name)
        if metanol_options.key? key
          metanol_options[key].value = value
          metanol_options[key].filters = filters
        else
          metanol_options[key] = meta_class.new(name, value, filters)
        end
      end

      def get_meta_by_type(type, name)
        key = get_meta_key(type, name)
        metanol_options.key?(key) ? metanol_options[key].value : nil
      end

      def get_meta_key(type, name)
        "#{type}:#{name}"
      end

    end

    SUPPORT_GROUPS.keys.each do |method|
      method_name = "#{method == :main ? '' : "#{method}_"}meta"
      define_method method_name do |*args|
        self.class.send(method_name, *args)
      end

      get_method_name = "get_#{method_name}"
      define_method get_method_name do |name|
        self.class.send(get_method_name, name)
      end
    end

    def metanol_options
      self.class.metanol_options
    end

  end

end