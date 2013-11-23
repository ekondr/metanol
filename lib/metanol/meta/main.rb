module Metanol::Meta

  class Main < Base
    def render
      return "<title>#{self.value}</title>" if @name == :title
      super
    end
  end

end