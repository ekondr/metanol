# frozen_string_literal: true

module Metanol
  module Meta
    class Main < Base
      def render
        return (value.present? ? "<title>#{value}</title>" : '') if @name == :title

        super
      end
    end
  end
end
