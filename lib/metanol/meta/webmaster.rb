module Metanol::Meta
  class Webmaster < Base

    SUPPORT_TAGS = {
        yandex: 'yandex-verification',
        google: 'google-site-verification',
        bing: 'msvalidate.01',
        alexa: 'alexaVerifyID'
    }

    def name
      SUPPORT_TAGS[@name]
    end

    protected

    def valid?(name)
      !SUPPORT_TAGS[name.to_sym].nil?
    end

  end
end