module Metanol::Meta

  class Base
    attr_reader :name
    attr_accessor :value

    def initialize(name, value)
      raise NameError.new "The meta tag '#{name}' isn't supported.", name unless valid?(name)
      @name = name
      @value = value
    end

    def render
      raise StandardError.new "Please override this method in a child class"
    end

    protected

    def valid?(name)
      true
    end
  end

end