module Util
  class ListAction < Trello::Action

    attr_reader :card, :card_id

    def initialize(fields={})
      super

      @card = data['card']['name']
      @card_id = data['card']['id']
    end

    def self.actions(client, board_id, options={})
      options = options.merge(filter: 'createCard,updateCard:idList,updateCard:closed')
      client.get("/boards/#{board_id}/actions", options).json_into(ListAction)
    end
  end
end
