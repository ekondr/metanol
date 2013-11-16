module Metanol::Meta

  class OpenGraph < Base
    SUPPORT_TAGS = [:title, :description, :url, :type, :locale, :site_name, :image]

    def render
      "<meta property=\"og:#{@name}\" content=\"#{@value}\" />"
    end

    def self.render_current_url(url)
      "<meta property=\"og:url\" content=\"#{url}\" />"
    end

    protected

    def valid?(name)
      SUPPORT_TAGS.include? name.to_sym
    end
  end

end