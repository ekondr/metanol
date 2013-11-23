module Metanol
  module Helpers

    # Render all meta tags
    def metanol_tags
      result = metanol_main_tags
      result << metanol_og_tags
      result << metanol_wm_tags
      result
    end

    # Render OpenGraph meta tags
    def metanol_og_tags
      result = metanol_render_tags ::Metanol::Meta::OpenGraph
      result << ::Metanol::Meta::OpenGraph.render_current_url(current_url).html_safe
      result
    end

    # Render Webmaster verification tags
    def metanol_wm_tags
      metanol_render_tags ::Metanol::Meta::Webmaster
    end

    # Render main tags, such as keywords, description, etc.
    def metanol_main_tags
      metanol_render_tags ::Metanol::Meta::Main
    end

    # Return a current URL
    def current_url
      request.original_url
    end

    def get_meta(name)
      self.controller.get_meta(name)
    end

    def get_og_meta(name)
      self.controller.get_og_meta(name)
    end

    def get_wm_meta(name)
      self.controller.get_wm_meta(name)
    end

    private

    def metanol_render_tags(type)
      result = ""
      self.controller.metanol_options.each_value do |value|
        next unless value.is_a? type
        result << value.render
      end
      result.html_safe
    end

  end
end