require_relative '../../../../utils/fetchers/stats_fetcher'
require 'date'

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
      options = {
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
      board = '{"id": "fsadfj823w", "name": "extort company", "actions": [], "cards": [], "members": [], "lists": []}'

      client = double(Trello::Client)
      expect(client).to receive(:get).with("/boards/#{board_id}", options).and_return(board)

      expect(StatsFetcher.fetch(client, board_id)).to eq JSON.parse(board)
    end

    it 'fetches more actions after fetching 1000' do
      board_id = "fsadfj823w"
      options = {
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
      actions = Array.new(1000, "")
      last_action_date = DateTime.now.to_s
      actions[-1] = {"date" => last_action_date} # '{"date": ' + last_action_date + '}' #{"date" => last_action_date}
      board = {"id" => "fsadfj823w", "name" => "extort company", "actions" => actions, "cards" => [], "members" => [], "lists" => []}

      client = double(Trello::Client)
      expect(client).to receive(:get).with("/boards/#{board_id}", options).and_return(JSON.fast_generate(board).to_s)

      action_options = {
        before: last_action_date,
        filter: :createCard,
        fields: "data,date",
        limit: 1000,
        memberCreator: false,
        member: false
      }
      expect(client).to receive(:get).with("/boards/#{board_id}/actions", action_options).and_return(JSON.fast_generate(Array.new(10, "")).to_s)

      board["actions"].concat Array.new(10, "")

      expect(StatsFetcher.fetch(client, board_id)).to eq board
    end
  end
end