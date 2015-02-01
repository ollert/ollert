require_relative '../../spec_helper'
require 'member_fetcher'

describe MemberFetcher do

  it_behaves_like 'a fetcher'

  describe '#fetch' do
    it 'uses client to get specified data' do
      token = "fsadfj823w"
      options = {fields: "username,gravatarHash,email"}
      member = '{"id": "fsadfj823w", "username": "tunahorder", "gratavarHash": "j1293jfds903ik", "email": "tuna@gmail.com"}'

      client = double(Trello::Client)
      expect(client).to receive(:get).with("/tokens/#{token}/member", options).and_return(member)

      expect(MemberFetcher.fetch(client, token)).to eq JSON.parse(member)
    end
  end
end