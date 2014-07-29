class WipFetcher
  def self.fetch(client, board_id)
    raise Trello::Error if client.nil? || board_id.nil? || board_id.empty?

    options = {filter: :open, cards: :open, card_fields: :none}

    client.get("/boards/#{board_id}/lists", options)
  end
end
