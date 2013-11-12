require 'rails'
require 'rspec/autorun'
require 'metanol'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
require 'rspec/rails'

RSpec.configure do |config|

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = true

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
end