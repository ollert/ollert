class WipFetcher
  def self.fetch(client, board_id)
    client.get("/boards/#{board_id}/lists", {filter: :open, cards: :open, card_fields: :none})
  end
end