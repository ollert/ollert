ENV['RACK_ENV'] = 'test'

require_relative '../../../web'

require 'capybara/cucumber'
require 'rspec'
require 'rack_session_access'
require 'rack_session_access/capybara'

Capybara.app = Ollert
Capybara.app.use RackSessionAccess::Middleware

World do
  Ollert.new

  Mongoid.purge!
end
