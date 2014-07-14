require_relative '../../../../utils/fetchers/wip_fetcher'

describe WipFetcher do
  describe '#fetch' do
    it 'returns empty object string for nil client' do
      expect(WipFetcher.fetch(nil, "fsadfj823w")).to eq "{}"
    end

    it 'returns empty object for nil board id' do
      client = double(Trello::Client)
      expect(WipFetcher.fetch(client, nil)).to eq "{}"
    end

    it 'returns empty object for empty board id' do
      client = double(Trello::Client)
      expect(WipFetcher.fetch(client, "")).to eq "{}"
    end

    it 'uses client to get lists' do
      board_id = "fsadfj823w"
      options = {filter: :open, cards: :open, card_fields: :none}
      lists = "{{'id': '123ij09dj', 'name': 'To Do', 'cards': {}}}"

      client = double(Trello::Client)
      expect(client).to receive(:get).with("/boards/#{board_id}/lists", options).and_return(lists)

      expect(WipFetcher.fetch(client, board_id)).to eq lists
    end
  end
end