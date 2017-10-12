require 'json'

class WipFetcher
  def self.fetch(client, board_id, show_archived=false)
    raise Trello::Error if client.nil? || board_id.nil? || board_id.empty?

    options = {filter: :open, cards: :open, card_fields: :none}
    if show_archived
      options[:cards] = :all
    end

    JSON.parse(client.get("/boards/#{board_id}/lists", options))
  end
end
