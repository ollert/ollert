require_relative '../../../../utils/fetchers/member_fetcher'

describe MemberFetcher do
  describe '#fetch' do
    it 'raises error on nil client' do
      expect {MemberFetcher.fetch(nil, "fsadfj823w")}.to raise_error(Trello::Error)
    end

    it 'raises error on nil member token' do
      expect {MemberFetcher.fetch(double(Trello::Client), nil)}.to raise_error(Trello::Error)
    end

    it 'raises error on empty member token' do
      expect {MemberFetcher.fetch(double(Trello::Client), "")}.to raise_error(Trello::Error)
    end
    
    it 'uses client to get specified data' do
      token = "fsadfj823w"
      options = {fields: "username,gravatarHash,email"}
      member = "{'id': 'fsadfj823w', 'username': 'tunahorder', 'gratavarHash': 'j1293jfds903ik', 'email': 'tuna@gmail.com'}"

      client = double(Trello::Client)
      expect(client).to receive(:get).with("/tokens/#{token}/member", options).and_return(member)

      expect(MemberFetcher.fetch(client, token)).to eq member
    end
  end
end