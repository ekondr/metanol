require File.join(File.dirname(__FILE__), 'meta/base')
require File.join(File.dirname(__FILE__), 'meta/main')
require File.join(File.dirname(__FILE__), 'meta/open_graph')

module Metanol

  # Engine's controller which has all methods for storing and processing meta tag's data
  module EngineController

    def metanol_options
      @metanol_options ||= {}
    end

    def meta(*args)
      if args[0].is_a? Hash
        args[0].each do |name, value|
          add_meta name, value
        end
      elsif args.length == 2
        name = args[0].to_sym
        value = args[1].to_sym
        add_meta name, value
      end
    end

    def og_meta(*args)
      if args[0].is_a? Hash
        args[0].each do |name, value|
          add_og_meta name, value
        end
      elsif args.length == 2
        name = args[0].to_sym
        value = args[1].to_sym
        add_og_meta name, value
      end
    end

    private

    def add_meta(name, value)
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

  end

end