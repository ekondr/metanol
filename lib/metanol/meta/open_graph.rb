module Metanol::Meta

  class OpenGraph < Base
    SUPPORT_TAGS = [:title, :description, :url, :type, :locale, :site_name, :image]

    # todo: init url with current url
    #<meta property="og:url" content="<?php bloginfo('url'); ?>" />

    def render
      "<meta property=\"og:#{@name}\" content=\"#{@value}\" />"
    end

    protected

    def valid?(name)
      SUPPORT_TAGS.include? name.to_sym
    end
  end

end