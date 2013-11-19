module Metanol::Meta

  class OpenGraph < Base
    def render
      "<meta property=\"og:#{@name}\" content=\"#{filtered_value}\" />"
    end

    def self.render_current_url(url)
      "<meta property=\"og:url\" content=\"#{url}\" />"
    end
  end

end