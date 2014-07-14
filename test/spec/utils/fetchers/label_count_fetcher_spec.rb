require_relative '../../../../utils/fetchers/label_count_fetcher'

describe LabelCountFetcher do
  describe '#fetch' do
    it 'returns empty object string for nil client' do
      expect(LabelCountFetcher.fetch(nil, "ori0kf34rf34jfjfrej")).to eq "{}"
    end

    it 'returns empty object for nil board id' do
      client = double(Trello::Client)
      expect(LabelCountFetcher.fetch(client, nil)).to eq "{}"
    end

    it 'returns empty object for empty board id' do
      client = double(Trello::Client)
      expect(LabelCountFetcher.fetch(client, "")).to eq "{}"
    end

    it 'uses client to get board' do
      board_id = "ori0kf34rf34jfjfrej"
      options = {cards: :open, card_fields: :labels, fields: :labelNames}
      board = "{'name': 'DS9', 'labelNames': {}, 'cards': {}, 'id': 'ori0kf34rf34jfjfrej'}"

      client = double(Trello::Client)
      expect(client).to receive(:get).with("/boards/#{board_id}", options).and_return(board)

      expect(LabelCountFetcher.fetch(client, board_id)).to eq board
    end
  end
end