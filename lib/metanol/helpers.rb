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
      # todo: take the locale and the type value from a config if a user hasn't set them in a controller
      metanol_render_tags ::Metanol::Meta::OpenGraph
    end

    # Render main tags, such as title, description, etc.
    def metanol_wm_tags
      metanol_render_tags ::Metanol::Meta::Webmaster
    end

    # Render main tags, such as title, description, etc.
    def metanol_main_tags
      metanol_render_tags ::Metanol::Meta::Main
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