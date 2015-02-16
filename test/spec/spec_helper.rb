$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'trello'
require 'require_all'
require 'dotenv'

require 'trello_integration_helper'

require_rel '../../utils'
Dotenv.load File.join(File.dirname(__FILE__), '../../', '.env')

Trello.configure do |config|
  config.developer_public_key = ENV['INTEGRATION_KEY']
  config.member_token = ENV['INTEGRATION_TOKEN']
end

RSpec.configure do |config|
  config.before(:suite) do
  end

  config.after(:suite) do
    TrelloIntegrationHelper.cleanup
  end
end

RSpec.shared_examples 'a fetcher' do
  it 'raises error on nil client' do
    expect {described_class.fetch(nil, "fsadfj823w")}.to raise_error(Trello::Error)
  end

  it 'raises error on nil member token' do
    expect {described_class.fetch(double(Trello::Client), nil)}.to raise_error(Trello::Error)
  end

  it 'raises error on empty member token' do
    expect {described_class.fetch(double(Trello::Client), "")}.to raise_error(Trello::Error)
  end
end
