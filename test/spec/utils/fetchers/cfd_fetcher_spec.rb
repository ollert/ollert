require_relative '../../../../utils/fetchers/cfd_fetcher'

describe CfdFetcher do
  describe '#fetch' do
    it 'raises error on nil client' do
      expect {CfdFetcher.fetch(nil, "ori0kf34rf34jfjfrej")}.to raise_error(Trello::Error)
    end

    it 'raises error on nil board id' do
      expect {CfdFetcher.fetch(double(Trello::Client), nil)}.to raise_error(Trello::Error)
    end

    it 'raises error on empty board id' do
      expect {CfdFetcher.fetch(double(Trello::Client), "")}.to raise_error(Trello::Error)
    end

    it 'uses client to get board' do
      board_id = "ori0kf34rf34jfjfrej"
      options =
      {
        actions: "createCard,updateCard:idList,updateList:closed",
        actions_limit: 1000,
        actions_fields: "type,date,data",
        lists: :all,
        list_fields: "name,closed"
      }
      board = "{'name': 'DS9', 'lists': {}, 'acitons': {}, 'id': 'ori0kf34rf34jfjfrej'}"

      client = double(Trello::Client)
      expect(client).to receive(:get).with("/boards/#{board_id}", options).and_return(board)

      expect(CfdFetcher.fetch(client, board_id)).to eq board
    end
  end
end