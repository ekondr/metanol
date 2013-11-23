module Metanol::Meta

  class OpenGraph < Base

    def self.render_current_url(url)
      !url.blank? ? "<meta property=\"og:url\" content=\"#{url}\" />" : ''
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