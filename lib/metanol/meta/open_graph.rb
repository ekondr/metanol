# frozen_string_literal: true

module Metanol
  module Meta
    class OpenGraph < Base
      def self.render_current_url(url)
        return '' if url.blank?

        "<meta property=\"og:url\" content=\"#{url}\" />"
      end

      def name
        "og:#{@name}"
      end

      protected

      def attr_name
        'property'
      end
    end
  end
end
