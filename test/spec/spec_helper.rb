$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'trello'
require 'require_all'
require 'dotenv'
require 'rspec/its'

require 'trello_integration_helper'
require_rel '../lib/core_ext/list'

require_rel '../../utils'
require_rel '../../helpers'

Dotenv.load File.join(File.dirname(__FILE__), '../../', '.env')

require 'rack/test'
require_relative '../../web'

Trello.configure do |config|
  config.developer_public_key = ENV['PUBLIC_KEY']
  config.member_token = ENV['MEMBER_TOKEN']
end

module OllertSpecs
  def app
    Ollert
  end

  def json_response_body
    @json_response_body ||= JSON.parse(last_response.body)
  end
end

require 'factory_girl'
FactoryGirl.definition_file_paths = [File.dirname(__FILE__) + '/factories']
FactoryGirl.find_definitions

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include OllertSpecs
  config.include FactoryGirl::Syntax::Methods

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
