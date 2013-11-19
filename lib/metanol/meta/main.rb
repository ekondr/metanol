module Metanol::Meta

  class Main < Base
    def render
      return "<title>#{filtered_value}</title>" if @name == :title
      "<meta name=\"#{@name}\" content=\"#{filtered_value}\" />"
    end
  end

end