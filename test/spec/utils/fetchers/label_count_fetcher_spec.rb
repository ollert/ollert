require_relative '../../spec_helper'

describe LabelCountFetcher do

  it_behaves_like 'a fetcher'

  describe '#fetch' do
    it 'uses client to get cards with labels' do
      board_id = "ori0kf34rf34jfjfrej"
      options = {fields: "labels,idList", actions: "createCard", limit: 1000, before: nil}
      cards = [{"labels" => [{"id" => "1", "color" => "green"}, {"id" => "3", "color" => "yellow"}], "actions" => [{"date" => "10-10-2016"}]},
               {"labels" => [{"id" => "3", "color" => "yellow"}], "actions" => [{"date" => "10-13-2016"}]},
               {"labels" => [{"id" => "2", "color" => "blue"}], "actions" => [{"date" => "10-15-2016"}]}]

      client = double(Trello::Client)
      expect(client).to receive(:get).with("/boards/#{board_id}/cards/open", options).and_return(cards.to_json)

      expect(LabelCountFetcher.fetch(client, board_id)).to eq cards
    end

    it 'tries to get additional cards if over limit' do
      board_id = "ori0kf34rf34jfjfrej"
      options = {fields: "labels,idList", actions: "createCard", limit: 1000, before: nil}
      cards = [{"labels" => [{"id" => "1", "color" => "green"}, {"id" => "3", "color" => "yellow"}], "actions" => [{"date" => "10-10-2016"}]},
               {"labels" => [{"id" => "3", "color" => "yellow"}], "actions" => [{"date" => "10-13-2016"}]},
               {"labels" => [{"id" => "2", "color" => "blue"}], "actions" => [{"date" => "10-15-2016"}]}]
      (0...997).each {
        cards << {}
      }

      client = double(Trello::Client)
      expect(client).to receive(:get).with("/boards/#{board_id}/cards/open", {fields: "labels,idList", actions: "createCard", limit: 1000, before: nil}).and_return(cards.to_json)
      options[:before] = "10-10-2016"
      expect(client).to receive(:get).with("/boards/#{board_id}/cards/open", options).and_return("[]")

      expect(LabelCountFetcher.fetch(client, board_id)).to eq cards
    end
  end
end
