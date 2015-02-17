require_relative '../../spec_helper'

describe LabelCountFetcher do

  it_behaves_like 'a fetcher'

  describe '#fetch' do
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
