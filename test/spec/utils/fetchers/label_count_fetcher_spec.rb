require_relative '../../spec_helper'

describe LabelCountFetcher do

  it_behaves_like 'a fetcher'

  describe '#fetch' do
    it 'uses client to get cards with labels' do
      board_id = "ori0kf34rf34jfjfrej"
      options = {fields: "labels", actions: 'createCard,convertToCardFromCheckItem,moveCardToBoard', limit: 300, before: nil}
      cards = [{"id" => "1", "labels" => [{"id" => "1", "color" => "green"}, {"id" => "3", "color" => "yellow"}], "actions" => [{"date" => "10-10-2016"}]},
               {"id" => "2", "labels" => [{"id" => "3", "color" => "yellow"}], "actions" => [{"date" => "10-13-2016"}]},
               {"id" => "3", "labels" => [{"id" => "2", "color" => "blue"}], "actions" => [{"date" => "10-15-2016"}]}]

      client = double(Trello::Client)
      expect(client).to receive(:get).with("/boards/#{board_id}/cards/visible", options).and_return(cards.to_json)

      expect(LabelCountFetcher.fetch(client, board_id, false)).to eq cards
    end

    it 'updates options and endpoint to show archived cards' do
      board_id = "ori0kf34rf34jfjfrej"
      options = {fields: "labels", actions: 'createCard,convertToCardFromCheckItem,moveCardToBoard', limit: 300, before: nil, filter: :all}
      cards = [{"id" => "1", "labels" => [{"id" => "1", "color" => "green"}, {"id" => "3", "color" => "yellow"}], "actions" => [{"date" => "10-10-2016"}]},
               {"id" => "2", "labels" => [{"id" => "3", "color" => "yellow"}], "actions" => [{"date" => "10-13-2016"}]},
               {"id" => "3", "labels" => [{"id" => "2", "color" => "blue"}], "actions" => [{"date" => "10-15-2016"}]}]

      client = double(Trello::Client)
      expect(client).to receive(:get).with("/boards/#{board_id}/cards", options).and_return(cards.to_json)

      expect(LabelCountFetcher.fetch(client, board_id, true)).to eq cards
    end

    it 'tries to get additional cards if over limit' do
      board_id = "ori0kf34rf34jfjfrej"
      options = {fields: "labels", actions: 'createCard,convertToCardFromCheckItem,moveCardToBoard', limit: 300, before: nil}
      cards = (0...750).map { |i| {"id" => i} }

      client = double(Trello::Client)
      expect(client).to receive(:get).with("/boards/#{board_id}/cards/visible", options).and_return(cards[0...300].to_json)
      expect(client).to receive(:get).with("/boards/#{board_id}/cards/visible", options.merge({before: 299})).and_return(cards[300...600].to_json)
      expect(client).to receive(:get).with("/boards/#{board_id}/cards/visible", options.merge({before: 599})).and_return(cards[600...750].to_json)

      expect(LabelCountFetcher.fetch(client, board_id, false)).to eq cards
    end

    it 'only returns unique entries' do
      # Not sure why the Trello API started returning duplicate entries, but we now use uniq! to filter them by id
      board_id = "ori0kf34rf34jfjfrej"
      options = {fields: "labels", actions: 'createCard,convertToCardFromCheckItem,moveCardToBoard', limit: 300, before: nil}
      cards = (0...6).map { |i| {"id" => i % 3} }

      client = double(Trello::Client)
      expect(client).to receive(:get).with("/boards/#{board_id}/cards/visible", options).and_return(cards.to_json)

      expect(LabelCountFetcher.fetch(client, board_id, false)).to eq [{"id" => 0}, {"id" => 1}, {"id" => 2}]
    end
  end
end
