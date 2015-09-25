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
require 'tilt/haml'

require_rel '../../../web', '../../spec/trello_integration_helper', '../../lib'

Capybara.app = Ollert
Capybara.default_max_wait_time = 10
Capybara.app.use RackSessionAccess::Middleware

Capybara.javascript_driver = :webkit

Capybara::Webkit.configure do |config|
  config.allow_url("*")
end

SitePrism.configure do |config|
  config.use_implicit_waits = true
end

World(OllertTest::Navigation) do
  Ollert.new
end

Trello.configure do |config|
  config.developer_public_key = ENV['PUBLIC_KEY']
  config.member_token = ENV['MEMBER_TOKEN']
end
