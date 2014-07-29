class LabelCountFetcher
  def self.fetch(client, board_id)
    raise Trello::Error if client.nil? || board_id.nil? || board_id.empty?

    options = {cards: :visible, card_fields: :labels, fields: :labelNames}

    client.get("/boards/#{board_id}", options)
  end
end
