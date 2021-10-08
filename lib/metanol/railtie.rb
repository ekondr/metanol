module Metanol
  class Railtie < ::Rails::Railtie # :nodoc:
    initializer 'metanolize' do |_app|
      ::ActionView::Base.include Metanol::Helpers
      ::ActionController::Base.include Metanol::EngineController
    end
  end
end
