require_relative 'fetcher'

module Utils
  module Fetchers
    class ListActionFetcher
      extend Utils::Fetcher

      def self.fetch(client, board_id, options={})
        options = options.merge(result_to: ListAction, filter: 'createCard,updateCard:idList', fields: 'data,type,date', member:false , memberCreator: false)
        all(client, "/boards/#{board_id}/actions", options)
      end
    end
  end
end
