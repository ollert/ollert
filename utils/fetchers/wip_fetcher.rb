class WipFetcher
  def self.fetch(client, board_id)
    raise Trello::Error if client.nil? || board_id.nil? || board_id.empty?
    client.get("/boards/#{board_id}/lists", {filter: :open, cards: :open, card_fields: :none})
  end
end