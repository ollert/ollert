require_relative '../../../../utils/fetchers/label_count_fetcher'
require 'date'

describe LabelCountFetcher do
  describe '#fetch' do
    it 'raises error on nil client' do
      expect {LabelCountFetcher.fetch(nil, "ori0kf34rf34jfjfrej")}.to raise_error(Trello::Error)
    end

    it 'raises error on nil board id' do
      expect {LabelCountFetcher.fetch(double(Trello::Client), nil)}.to raise_error(Trello::Error)
    end

    it 'raises error on empty board id' do
      expect {LabelCountFetcher.fetch(double(Trello::Client), "")}.to raise_error(Trello::Error)
    end
    
    it 'uses client to get board' do
      board_id = "ori0kf34rf34jfjfrej"
      options = {cards: :visible, card_fields: :labels, fields: :labelNames}
      board = "{'name': 'DS9', 'labelNames': {}, 'cards': {}, 'id': 'ori0kf34rf34jfjfrej'}"

      client = double(Trello::Client)
      expect(client).to receive(:get).with("/boards/#{board_id}", options).and_return(board)

      expect(LabelCountFetcher.fetch(client, board_id)).to eq board
    end

    it 'constrains fetch by date' do
      to_date = DateTime.strptime('1405965784', '%s')
      from_date = DateTime.strptime('12345', '%s')
      board_id = "ori0kf34rf34jfjfrej"
      options = {
        cards: :visible,
        card_fields: :labels,
        fields: :labelNames,
        before: to_date.to_s,
        since: from_date.to_s
      }
      board = "{'name': 'DS9', 'labelNames': {}, 'cards': {}, 'id': 'ori0kf34rf34jfjfrej'}"

      client = double(Trello::Client)
      expect(client).to receive(:get).with("/boards/#{board_id}", options).and_return(board)

      expect(LabelCountFetcher.fetch(client, board_id, date_to: to_date, date_from: from_date)).to eq board
    end
  end
end
