require 'dotenv'
Dotenv.load File.join(File.dirname(__FILE__), '../../..', '.env')

ENV['RACK_ENV'] = 'test'

require 'capybara/cucumber'
require 'rspec'
require 'rack_session_access'
require 'rack_session_access/capybara'
require 'site_prism'

require 'capybara/webkit'
require 'require_all'

require_rel '../../../web'
require_rel '../../lib'

Capybara.app = Ollert
Capybara.default_wait_time = 10
Capybara.app.use RackSessionAccess::Middleware

Capybara.javascript_driver = :webkit

SitePrism.configure do |config|
  config.use_implicit_waits = true
end

World(OllertTest::Navigation) do
  Ollert.new
end
