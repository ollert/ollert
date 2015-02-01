require_relative '../../spec_helper'
require 'wip_fetcher'

describe WipFetcher do

  it_behaves_like 'a fetcher'

  describe '#fetch' do
    it 'uses client to get lists' do
      board_id = "fsadfj823w"
      options = {filter: :open, cards: :open, card_fields: :none}
      lists = '{"id": "123ij09dj", "name": "To Do", "cards": {}}'

      client = double(Trello::Client)
      expect(client).to receive(:get).with("/boards/#{board_id}/lists", options).and_return(lists)

      expect(WipFetcher.fetch(client, board_id)).to eq JSON.parse(lists)
    end
  end
end
