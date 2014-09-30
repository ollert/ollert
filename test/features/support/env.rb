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
  Mongoid.purge!
end

After do
  user = User.find_by(email: ENV['TRELLO_TEST_USERNAME'])
  if !user.nil? && !user.member_token.nil?
    client = Trello::Client.new(
      developer_public_key: ENV['PUBLIC_KEY'],
      member_token: user.member_token
    )

    client.delete("/tokens/#{user.member_token}")
  end
end