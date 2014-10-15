require_relative '../../../../utils/fetchers/progress_charts_fetcher'

describe ProgressChartsFetcher do
  describe '#fetch' do
    it 'raises error on nil client' do
      expect {ProgressChartsFetcher.fetch(nil, "ori0kf34rf34jfjfrej")}.to raise_error(Trello::Error)
    end

    it 'raises error on nil board id' do
      expect {ProgressChartsFetcher.fetch(double(Trello::Client), nil)}.to raise_error(Trello::Error)
    end

    it 'raises error on empty board id' do
      expect {ProgressChartsFetcher.fetch(double(Trello::Client), "")}.to raise_error(Trello::Error)
    end

    it 'uses client to get board' do
      board_id = "ori0kf34rf34jfjfrej"
      options =
      {
        actions: "createCard,updateCard:idList,updateCard:closed,updateList:closed",
        actions_limit: 1000,
        action_fields: "data,type,date",
        action_memberCreator: :false,
        action_member: false,
        lists: :all,
        list_fields: "name,closed",
        fields: "name"
      }
      board = "{'name': 'DS9', 'lists': {}, 'actions': {}, 'id': 'ori0kf34rf34jfjfrej'}"

      client = double(Trello::Client)
      expect(client).to receive(:get).with("/boards/#{board_id}", options).and_return(board)

      expect(ProgressChartsFetcher.fetch(client, board_id)).to eq board
    end
  end

  describe '#fetch_actions' do
    it 'raises error on nil client' do
      expect {ProgressChartsFetcher.fetch_actions(nil, "fsadfj823w", DateTime.now)}.to raise_error(Trello::Error)
    end

    it 'raises error on nil board id' do
      expect {ProgressChartsFetcher.fetch_actions(double(Trello::Client), nil, DateTime.now)}.to raise_error(Trello::Error)
    end

    it 'raises error on nil empty id' do
      expect {ProgressChartsFetcher.fetch_actions(double(Trello::Client), "", DateTime.now)}.to raise_error(Trello::Error)
    end

    it 'raises error on nil date' do
      expect {ProgressChartsFetcher.fetch_actions(double(Trello::Client), "dsafsddsa", nil)}.to raise_error(Trello::Error)
    end
    
    it 'uses client to get board data' do
      board_id = "fsadfj823w"
      date = DateTime.now
      options =
      {
        filter: "createCard,updateCard:idList,updateCard:closed,updateList:closed",
        fields: "data,type,date",
        limit: 1000,
        before: date,
        memberCreator: false,
        member: false,
      }
      actions = "[]"

      client = double(Trello::Client)
      expect(client).to receive(:get).with("/boards/#{board_id}/actions", options).and_return(actions)

      expect(ProgressChartsFetcher.fetch_actions(client, board_id, date)).to eq actions
    end
  end
end
