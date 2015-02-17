require 'dotenv'
Dotenv.load File.join(File.dirname(__FILE__), '../../..', '.env')

ENV['RACK_ENV'] = 'test'

require_relative '../../../web'

require 'capybara/cucumber'
require 'rspec'
require 'rack_session_access'
require 'rack_session_access/capybara'

require 'capybara/webkit'

Capybara.app = Ollert
Capybara.default_wait_time = 10
Capybara.app.use RackSessionAccess::Middleware

Capybara.javascript_driver = :webkit

World do
  Ollert.new
end
