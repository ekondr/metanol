module Metanol::Meta

  class Base
    attr_reader :name
    attr_accessor :value

    SUPPORTED_FILTERS = [:html, :overspaces, :whitespaces, :clean]

    def initialize(name, value, filters=[])
      raise NameError.new "The meta tag '#{name}' isn't supported.", name unless valid?(name)
      @name = name
      @value = value
      self.filters = filters
    end

    def filters=(value)
      @filters = validate_filters(value)
    end

    def render
      raise StandardError.new "Please override this method in a child class"
    end

    def self.filter_html(text)
      text = text.gsub(/\<br\/?\>/, ' ')
      text.gsub(/\<\/?\w+\/?\>/, '')
    end

    def self.filter_overspaces(text)
      text.gsub(/[\ ]{2,}/, ' ')
    end

    def self.filter_whitespaces(text)
      text.gsub(/\s/, ' ')
    end

    protected

    def valid?(name)
      true
    end

    def filtered_value
      result = @value
      return result unless filters?
      result = self.class.filter_html(result) if @filters.include?(:html) || @filters.include?(:clean)
      result = self.class.filter_whitespaces(result) if @filters.include?(:whitespaces) || @filters.include?(:clean)
      result = self.class.filter_overspaces(result) if @filters.include?(:overspaces) || @filters.include?(:clean)
      result
    end

    def filters?
      @filters && !@filters.empty?
    end

    private

    def validate_filters(filters=[])
      result = []
      raise StandardError.new("The filters parameter must be an Array.") unless filters.is_a?(Array)
      begin
        filters.each do |filter|
          filter_value = filter.to_sym
          StandardError.new("Only #{SUPPORTED_FILTERS.join(', ')} filters are supported.") unless SUPPORTED_FILTERS.include? filter_value
          result << filter_value
        end
      rescue NoMethodError
        raise StandardError.new("The filters parameter must includes only string or symbol values.")
      end
      result
    end

  end

end