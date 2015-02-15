require_relative 'fetchers/fetcher'

module Util
  class ListAction < Trello::BasicData
    extend Util::Fetcher

    attr_reader :card, :card_id, :before, :before_id, :after, :after_id, :data, :date, :type

    def initialize(fields={})
      @data, @date, @type  = fields['data'], fields['date'], fields['type']

      @card, @card_id = name_and_id data['card']
      @before, @before_id = name_and_id data['listBefore']
      @after, @after_id = name_and_id data['listAfter'] || data['list']
    end

    class << self
      def actions(client, board_id, options={})
        options = options.merge(result_to: ListAction, filter: 'createCard,updateCard:idList', fields: 'data,type,date', member:false , memberCreator: false)
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
