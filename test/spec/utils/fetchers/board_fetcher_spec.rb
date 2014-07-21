require_relative '../../../../utils/fetchers/board_fetcher'

describe BoardFetcher do
  describe '#fetch' do
    it 'raises error on nil client' do
      expect {BoardFetcher.fetch(nil, "bensisko")}.to raise_error(Trello::Error)
    end

    it 'raises error on nil member id' do
      expect {BoardFetcher.fetch(double(Trello::Client), nil)}.to raise_error(Trello::Error)
    end

    it 'raises error on empty member id' do
      expect {BoardFetcher.fetch(double(Trello::Client), "")}.to raise_error(Trello::Error)
    end

    it 'uses client to get member boards' do
      member_id = "bensisko"
      options = {filter: :open, fields: :name, organization: true}
      boards = "{{'organization': 'Starfleet', 'name': 'DS9', 'id': 'u19234e9jfd10'}}"

      client = double(Trello::Client)
      expect(client).to receive(:get).with("/members/#{member_id}/boards", options).and_return(boards)

      expect(BoardFetcher.fetch(client, member_id)).to eq boards
    end
  end
end
