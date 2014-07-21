require_relative 'fetcher'

class LabelCountFetcher
  def self.fetch(client, board_id, parameters = {})
    raise Trello::Error if client.nil? || board_id.nil? || board_id.empty?

    options = {cards: :visible, card_fields: :labels, fields: :labelNames}
    Fetcher.merge_date_option!(options, parameters)

    client.get("/boards/#{board_id}", options)
  end
end
