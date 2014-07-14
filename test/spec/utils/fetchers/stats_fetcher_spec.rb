require_relative '../../../../utils/fetchers/stats_fetcher'

describe StatsFetcher do
  describe '#fetch' do
    it 'returns empty object string for nil client' do
      expect(StatsFetcher.fetch(nil, "fsadfj823w")).to eq "{}"
    end

    it 'returns empty object for nil token' do
      client = double(Trello::Client)
      expect(StatsFetcher.fetch(client, nil)).to eq "{}"
    end

    it 'returns empty object for empty token' do
      client = double(Trello::Client)
      expect(StatsFetcher.fetch(client, "")).to eq "{}"
    end

    it 'uses client to get member' do
      board_id = "fsadfj823w"
      options =
      {
        fields: "name",
        actions: :createCard,
        action_fields: "date,data",
        cards: :all,
        card_fields: "idList,name,idMembers",
        members: :all,
        member_fields: :fullName,
        lists: :open
      }
      board = "{'id': 'fsadfj823w', 'name': 'extort company', 'actions': {}, 'cards': {}, 'members': {}, 'lists': {}}"

      client = double(Trello::Client)
      expect(client).to receive(:get).with("/boards/#{board_id}", options).and_return(board)

      expect(StatsFetcher.fetch(client, board_id)).to eq board
    end
  end
end