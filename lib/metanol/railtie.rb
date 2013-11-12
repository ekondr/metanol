module Metanol
  class Railtie < ::Rails::Railtie #:nodoc:
    initializer 'metanolize' do |app|
      ::ActionView::Base.send :include, Metanol::Helpers
      ::ActionController::Base.send :include, Metanol::EngineController
    end
  end
end