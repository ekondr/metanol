module Metanol::Meta
  class Webmaster < Base

    SUPPORT_TAGS = {
        yandex: 'yandex-verification',
        google: 'google-site-verification',
        bing: 'msvalidate.01',
        alexa: 'alexaVerifyID'
    }

    def render
      "<meta name=\"#{SUPPORT_TAGS[@name]}\" content=\"#{filtered_value}\" />"
    end

    protected

    def valid?(name)
      !SUPPORT_TAGS[name.to_sym].nil?
    end

  end
end