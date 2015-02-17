require_relative 'fetchers/fetcher'

module Utils
  class ListAction < Trello::BasicData
    attr_reader :card, :card_id, :before, :before_id, :after, :after_id, :data, :date, :type

    def initialize(fields={})
      @data, @date, @type  = fields['data'], fields['date'], fields['type']

      @card, @card_id = name_and_id data['card']
      @before, @before_id = name_and_id data['listBefore']
      @after, @after_id = name_and_id data['listAfter'] || data['list']
    end

    private
    def name_and_id(hash)
      return nil unless hash
      [hash['name'], hash['id']]
    end
  end
end
