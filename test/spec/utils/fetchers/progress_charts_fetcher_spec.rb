require_relative '../../spec_helper'

describe ProgressChartsFetcher do

  it_behaves_like 'a fetcher'

  describe '#fetch' do
    it 'uses client to get board' do
      board_id = "ori0kf34rf34jfjfrej"
      options = {
        actions: "createCard,updateCard:idList,updateCard:closed",
        actions_limit: 1000,
        action_fields: "data,type,date",
        action_memberCreator: :false,
        action_member: false,
        lists: :all,
        list_fields: "name,closed",
        fields: "name"
      }
      board = {'name' => 'DS9', 'lists' => {}, 'actions' => {}, 'id' => 'ori0kf34rf34jfjfrej'}

      client = double(Trello::Client)
      expect(client).to receive(:get).with("/boards/#{board_id}", options).and_return(JSON.generate(board).to_s)

      expect(ProgressChartsFetcher.fetch(client, board_id)).to eq board
    end

    it 'fetches additional actions when more than 1000 returned' do
      board_id = "ori0kf34rf34jfjfrej"
      options = {
        actions: "createCard,updateCard:idList,updateCard:closed",
        actions_limit: 1000,
        action_fields: "data,type,date",
        action_memberCreator: :false,
        action_member: false,
        lists: :all,
        list_fields: "name,closed",
        fields: "name"
      }

      actions = Array.new(1000, "")
      last_action_date = DateTime.now.to_s
      actions[-1] = {"date" => last_action_date}
      board = {'name' => 'DS9', 'lists' => {}, 'actions' => actions, 'id' => 'ori0kf34rf34jfjfrej'}

      client = double(Trello::Client)
      expect(client).to receive(:get).with("/boards/#{board_id}", options).and_return(JSON.fast_generate(board).to_s)

      action_options = {
        before: last_action_date,
        filter: "createCard,updateCard:idList,updateCard:closed",
        fields: "data,type,date",
        limit: 1000,
        memberCreator: false,
        member: false
      }
      expect(client).to receive(:get).with("/boards/#{board_id}/actions", action_options).and_return(JSON.fast_generate(Array.new(10, "")).to_s)

      board["actions"].concat Array.new(10, "")

      expect(ProgressChartsFetcher.fetch(client, board_id)).to eq board
    end
  end
end
