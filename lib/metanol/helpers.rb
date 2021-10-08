module Metanol
  module Helpers
    # Render all meta tags
    def metanol_tags
      result = ''
      SUPPORT_GROUPS.keys.each do |type|
        result << send("metanol_#{type}_tags")
      end
      result.html_safe
    end

    # Render OpenGraph meta tags
    def metanol_og_tags
      result = metanol_render_tags ::Metanol::Meta::OpenGraph
      result << ::Metanol::Meta::OpenGraph.render_current_url(current_url)
      result.html_safe
    end

    SUPPORT_GROUPS.keys.each do |method|
      get_method_name = "get_#{method == :main ? '' : "#{method}_"}meta"
      define_method get_method_name do |name|
        controller.__send__(get_method_name, name)
      end

      next if method == :og

      method_name = "metanol_#{method}_tags"
      class_type = SUPPORT_GROUPS[method]
      define_method method_name do
        metanol_render_tags(class_type).html_safe
      end
    end

    # Return a current URL
    def current_url
      request.original_url
    end

    private

    def metanol_render_tags(type)
      result = ''
      metanols = controller.class.common_metanols.merge(controller.action_metanols)
      metanols.each_value do |value|
        next unless value.is_a? type

        result << value.render
      end
      result
    end
  end
end
