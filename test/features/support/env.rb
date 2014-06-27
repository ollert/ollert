ENV['RACK_ENV'] = 'test'
ENV['SESSION_SECRET'] = "Quiet, you"

require_relative '../../../web'

require 'capybara/cucumber'
require 'rspec'

Capybara.app = Ollert

World do
  Ollert.new

  Mongoid.purge!
end
