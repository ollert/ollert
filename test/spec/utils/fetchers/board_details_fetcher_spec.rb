require_relative '../../spec_helper'

describe BoardDetailsFetcher do

  it_behaves_like 'a fetcher'

  describe '#fetch' do
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
