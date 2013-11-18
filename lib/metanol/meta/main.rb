module Metanol::Meta

  class Main < Base
    def render
      return "<title>#{@value}</title>" if @name == :title
      "<meta name=\"#{@name}\" content=\"#{@value}\" />"
    end
  end

end