require_relative 'fetcher'

class WipFetcher
  def self.fetch(client, board_id, parameters = {})
    raise Trello::Error if client.nil? || board_id.nil? || board_id.empty?

    options = {filter: :open, cards: :open, card_fields: :none}
    Fetcher.merge_date_option!(options, parameters)

    client.get("/boards/#{board_id}/lists", options)
  end
end
