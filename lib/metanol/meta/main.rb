module Metanol::Meta

  class Main < Base
    def render
      "<meta name=\"#{@name}\" content=\"#{@value}\" />"
    end
  end

end