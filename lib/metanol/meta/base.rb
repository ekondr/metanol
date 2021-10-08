# frozen_string_literal: true

module Metanol
  module Meta
    class Base
      ERR_FILTERS_WRONG_TYPE = 'The <filters> parameter must be an Array.'
      ERR_FILTERS_WRONG_VALUE_TYPE =
        'The <filters> parameter must include only string or symbol values.'
      SUPPORTED_FILTERS = %i[html overspaces whitespaces clean].freeze

      attr_writer :value
      attr_reader :name

      def initialize(name, value, filters = [])
        @name = name.to_sym
        raise(NameError.new("The meta tag '#{@name}' isn't supported.", @name)) unless valid?(@name)

        @value = value
        self.filters = filters
      end

      def filters=(value)
        @filters = validate_filters(value)
      end

      def render
        result = value
        return '' if result.blank?

        "<meta #{attr_name}=\"#{name}\" #{attr_value}=\"#{result}\" />"
      end

      def value
        result = @value
        return result if @filters.blank?

        filter_overspaces(filter_whitespaces(filter_html_tags(result)))
      end

      def self.filter_html(text)
        text = text.gsub(%r{<br/?>}, ' ')
        text.gsub(%r{</?\w+/?>}, '')
      end

      def self.filter_overspaces(text)
        text.gsub(/\ {2,}/, ' ')
      end

      def self.filter_whitespaces(text)
        text.gsub(/\s/, ' ')
      end

      private

      def valid?(_name)
        true
      end

      def attr_name
        'name'
      end

      def attr_value
        'content'
      end

      def validate_filters(filters = [])
        result = []
        raise StandardError, ERR_FILTERS_WRONG_TYPE unless filters.is_a?(Array)

        begin
          filters.map(&:to_sym).each do |filter_value|
            result << validate_filter(filter_value)
          end
        rescue NoMethodError
          raise StandardError, ERR_FILTERS_WRONG_VALUE_TYPE
        end
        result
      end

      def validate_filter(filter_value)
        return filter_value if SUPPORTED_FILTERS.include? filter_value

        raise(StandardError, "Only #{SUPPORTED_FILTERS.join(', ')} filters are supported.")
      end

      def filter_html_tags(result)
        (@filters & %i[html clean]).presence ? self.class.filter_html(result) : result
      end

      def filter_whitespaces(result)
        (@filters & %i[whitespaces clean]).presence ? self.class.filter_whitespaces(result) : result
      end

      def filter_overspaces(result)
        (@filters & %i[overspaces clean]).presence ? self.class.filter_overspaces(result) : result
      end
    end
  end
end
