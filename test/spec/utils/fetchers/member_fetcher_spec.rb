require_relative '../../../../utils/fetchers/member_fetcher'

describe MemberFetcher do
  describe '#fetch' do
    it 'uses client to get member' do
      token = "fsadfj823w"
      options = {fields: :username}
      member = "{'id': 'fsadfj823w', 'username': 'tunahorder'}"

      client = double(Trello::Client)
      expect(client).to receive(:get).with("/tokens/#{token}/member", options).and_return(member)

      expect(MemberFetcher.fetch(client, token)).to eq member
    end
  end
end