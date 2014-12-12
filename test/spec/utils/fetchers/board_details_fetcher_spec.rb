require_relative '../../../../utils/fetchers/board_details_fetcher'

describe BoardDetailsFetcher do
  describe '#fetch' do
    it 'raises error on nil client' do
      expect {BoardDetailsFetcher.fetch(nil, "fsadfj823w")}.to raise_error(Trello::Error)
    end

    it 'raises error on nil board id' do
      expect {BoardDetailsFetcher.fetch(double(Trello::Client), nil)}.to raise_error(Trello::Error)
    end

    it 'raises error on empty board id' do
      expect {BoardDetailsFetcher.fetch(double(Trello::Client), "")}.to raise_error(Trello::Error)
    end
    
    it 'uses client to get details' do
      board_id = "fsadfj823w"
      options = {filter: :open, lists: :open, fields: :name}
      lists = '{"id": "123ij09dj", "name": "To Do", "lists": [{"name": "one", "id": "d2korjuf9023"},{"name": "two", "id": "31i9fjrjg5h"}]}'

      client = double(Trello::Client)
      expect(client).to receive(:get).with("/boards/#{board_id}", options).and_return(lists)

      expect(BoardDetailsFetcher.fetch(client, board_id)).to eq JSON.parse(lists)
    end
  end
end
