module Util
  class ListAction < Trello::Action

    attr_reader :card, :card_id

    def initialize(fields={})
      super

      @card = data['card']['name']
      @card_id = data['card']['id']
    end

    def self.actions(client, board_id)
      client.get("/boards/#{board_id}/actions", filter: 'createCard').json_into(ListAction)
    end
  end
end
