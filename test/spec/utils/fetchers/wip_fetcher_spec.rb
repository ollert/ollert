require_relative '../../../../utils/fetchers/wip_fetcher'

describe WipFetcher do
  describe '#fetch' do
    it 'raises error on nil client' do
      expect {WipFetcher.fetch(nil, "fsadfj823w")}.to raise_error(Trello::Error)
    end

    it 'raises error on nil board id' do
      expect {WipFetcher.fetch(double(Trello::Client), nil)}.to raise_error(Trello::Error)
    end

    it 'raises error on empty board id' do
      expect {WipFetcher.fetch(double(Trello::Client), "")}.to raise_error(Trello::Error)
    end
    
    it 'uses client to get lists' do
      board_id = "fsadfj823w"
      options = {filter: :open, cards: :open, card_fields: :none}
      lists = "{{'id': '123ij09dj', 'name': 'To Do', 'cards': {}}}"

      client = double(Trello::Client)
      expect(client).to receive(:get).with("/boards/#{board_id}/lists", options).and_return(lists)

      expect(WipFetcher.fetch(client, board_id)).to eq lists
    end

    it 'constrains fetch by date' do
      to_date = DateTime.strptime('1405965784', '%s')
      from_date = DateTime.strptime('12345', '%s')
      board_id = "fsadfj823w"
      options = {
        filter: :open,
        cards: :open,
        card_fields: :none,
        since: from_date.to_s,
        before: to_date.to_s
      }
      lists = "{{'id': '123ij09dj', 'name': 'To Do', 'cards': {}}}"

      client = double(Trello::Client)
      expect(client).to receive(:get).with("/boards/#{board_id}/lists", options).and_return(lists)

      expect(WipFetcher.fetch(client, board_id, date_from: from_date, date_to: to_date)).to eq lists
    end
  end
end
