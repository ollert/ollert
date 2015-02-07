require_relative 'fetchers/fetcher'

module Util
  class ListAction < Trello::Action
    extend Util::Fetcher

    attr_reader :card, :card_id, :before, :before_id, :after, :after_id

    def initialize(fields={})
      super

      @card, @card_id = name_and_id data['card']
      @before, @before_id = name_and_id data['listBefore']
      @after, @after_id = name_and_id data['listAfter'] || data['list']
    end

    class << self
      def actions(client, board_id, options={})
        options = options.merge(result_to: ListAction, filter: 'createCard,updateCard:idList,updateCard:closed')
        all(client, "/boards/#{board_id}/actions", options)
      end
    end

    private
    def name_and_id(hash)
      return nil unless hash
      [hash['name'], hash['id']]
    end
  end
end
