require_relative '../../spec_helper'

describe WipFetcher do

  it_behaves_like 'a fetcher'

  describe '#fetch' do
    it 'uses client to get lists' do
      board_id = "fsadfj823w"
      options = {filter: :open, cards: :open, card_fields: :none}
      lists = '{"id": "123ij09dj", "name": "To Do", "cards": {}}'

      client = double(Trello::Client)
      expect(client).to receive(:get).with("/boards/#{board_id}/lists", options).and_return(lists)

      expect(WipFetcher.fetch(client, board_id, false)).to eq JSON.parse(lists)
    end

    it 'updates options for showing archived cards' do
      board_id = "fsadfj823w"
      options = {filter: :open, cards: :all, card_fields: :none}
      lists = '{"id": "123ij09dj", "name": "To Do", "cards": {}}'

      client = double(Trello::Client)
      expect(client).to receive(:get).with("/boards/#{board_id}/lists", options).and_return(lists)

      expect(WipFetcher.fetch(client, board_id, true)).to eq JSON.parse(lists)
    end
  end
end
