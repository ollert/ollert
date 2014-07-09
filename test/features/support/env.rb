ENV['RACK_ENV'] = 'test'

require_relative '../../../web'

require 'capybara/cucumber'
require 'rspec'
require 'rack_session_access'
require 'rack_session_access/capybara'

require 'capybara/webkit'

Capybara.app = Ollert
Capybara.app.use RackSessionAccess::Middleware

Capybara.javascript_driver = :webkit

World do
  Ollert.new

  Mongoid.purge!
end

require 'email_spec'
require 'email_spec/cucumber'
