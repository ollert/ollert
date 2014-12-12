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
      options = {:fields=>"color,name,uses", :limit=>100}
      board = '{"name": "DS9", "labelNames": {}, "cards": {}, "id": "ori0kf34rf34jfjfrej"}'

      client = double(Trello::Client)
      expect(client).to receive(:get).with("/boards/#{board_id}/labels", options).and_return(board)

      expect(LabelCountFetcher.fetch(client, board_id)).to eq JSON.parse(board)
    end
  end
end
