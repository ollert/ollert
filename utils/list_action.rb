require_relative 'fetchers/fetcher'

module Util
  class ListAction < Trello::Action
    extend Util::Fetcher

    attr_reader :card, :card_id

    def initialize(fields={})
      super

      @card = data['card']['name']
      @card_id = data['card']['id']
    end

    def self.actions(client, board_id, options={})
      options = options.merge(result_to: ListAction, filter: 'createCard,updateCard:idList,updateCard:closed')
      all(client, "/boards/#{board_id}/actions", options)
    end
  end
end
