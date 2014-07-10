class LabelCountFetcher
  def self.fetch(client, board_id)
    client.get("/boards/#{board_id}", {cards: :open, card_fields: :labels, fields: :labelNames})
  end
end