# frozen_string_literal: true

module Metanol
  module Meta
    class Webmaster < Base
      SUPPORT_TAGS = {
        bing: 'msvalidate.01',
        alexa: 'alexaVerifyID',
        yandex: 'yandex-verification',
        google: 'google-site-verification'
      }.freeze

      def name
        SUPPORT_TAGS[@name]
      end

      protected

      def valid?(name)
        SUPPORT_TAGS[name].present?
      end
    end
  end
end
