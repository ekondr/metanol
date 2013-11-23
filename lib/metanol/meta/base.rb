module Metanol::Meta

  class Base
    attr_writer :value

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
      result = self.value
      !result.blank? ? "<meta #{self.attr_name}=\"#{self.name}\" #{self.attr_value}=\"#{result}\" />" : ''
    end

    def name
      @name
    end

    def value
      result = @value
      return result unless filters?
      result = self.class.filter_html(result) if @filters.include?(:html) || @filters.include?(:clean)
      result = self.class.filter_whitespaces(result) if @filters.include?(:whitespaces) || @filters.include?(:clean)
      result = self.class.filter_overspaces(result) if @filters.include?(:overspaces) || @filters.include?(:clean)
      result
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

    def filters?
      @filters && !@filters.empty?
    end

    def attr_name
      'name'
    end

    def attr_value
      'content'
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