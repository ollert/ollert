require 'json'

class LabelCountFetcher
  def self.fetch(client, board_id, show_archived=false)
    raise Trello::Error if client.nil? || board_id.nil? || board_id.empty?

    options = {
      fields: "labels",
      actions: "createCard,convertToCardFromCheckItem,moveCardToBoard",
      limit: 300
    }

    endpoint = "/boards/#{board_id}/cards/visible"
    if show_archived
      endpoint = "/boards/#{board_id}/cards"
      options[:filter] = :all
    end

    cards = []
    before = nil
    loop do
      newCards = JSON.parse(client.get(endpoint, options.merge({before: before})))
      cards.concat newCards
      break unless newCards.count == 300

      before = newCards.last["id"]
    end
    cards.uniq!{|c| c["id"]}
    cards
  end
end
