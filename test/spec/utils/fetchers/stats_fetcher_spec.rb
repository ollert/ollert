require_relative '../../../../utils/fetchers/stats_fetcher'

describe StatsFetcher do
  describe '#fetch' do
    it 'raises error on nil client' do
      expect {StatsFetcher.fetch(nil, "fsadfj823w")}.to raise_error(Trello::Error)
    end

    it 'raises error on nil board id' do
      expect {StatsFetcher.fetch(double(Trello::Client), nil)}.to raise_error(Trello::Error)
    end

    it 'raises error on nil empty id' do
      expect {StatsFetcher.fetch(double(Trello::Client), "")}.to raise_error(Trello::Error)
    end
    
    it 'uses client to get board data' do
      board_id = "fsadfj823w"
      options =
      {
        fields: "name",
        actions: :createCard,
        action_fields: "date,data",
        action_memberCreator: :false,
        action_member: false,
        actions_limit: 1000,
        cards: :visible,
        card_fields: "idList,name,idMembers",
        members: :all,
        member_fields: :fullName,
        lists: :open,
        list_fields: "name,closed",
      }
      board = "{'id': 'fsadfj823w', 'name': 'extort company', 'actions': {}, 'cards': {}, 'members': {}, 'lists': {}}"

      client = double(Trello::Client)
      expect(client).to receive(:get).with("/boards/#{board_id}", options).and_return(board)

      expect(StatsFetcher.fetch(client, board_id)).to eq board
    end
  end

  describe '#fetch_actions' do
    it 'raises error on nil client' do
      expect {StatsFetcher.fetch_actions(nil, "fsadfj823w", DateTime.now)}.to raise_error(Trello::Error)
    end

    it 'raises error on nil board id' do
      expect {StatsFetcher.fetch_actions(double(Trello::Client), nil, DateTime.now)}.to raise_error(Trello::Error)
    end

    it 'raises error on nil empty id' do
      expect {StatsFetcher.fetch_actions(double(Trello::Client), "", DateTime.now)}.to raise_error(Trello::Error)
    end

    it 'raises error on nil date' do
      expect {StatsFetcher.fetch_actions(double(Trello::Client), "dsafsddsa", nil)}.to raise_error(Trello::Error)
    end
    
    it 'uses client to get board data' do
      board_id = "fsadfj823w"
      date = DateTime.now
      options =
      {
        filter: :createCard,
        fields: "data,date",
        limit: 1000,
        before: date,
        memberCreator: false,
        member: false
      }
      actions = "[]"

      client = double(Trello::Client)
      expect(client).to receive(:get).with("/boards/#{board_id}/actions", options).and_return(actions)

      expect(StatsFetcher.fetch_actions(client, board_id, date)).to eq actions
    end
  end
end
