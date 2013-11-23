module Metanol::Meta

  class Main < Base
    def render
      result = self.value
      return (!result.blank? ? "<title>#{result}</title>": '') if @name == :title
      super
    end
  end

end