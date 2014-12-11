class CycleTimeFetcher
  def self.fetch(client, board_id)
    cards = JSON.parse(self.fetch_cards(client, board_id))
    fetched = cards.count
    while fetched == 1000
      more_cards = JSON.parse(action_fetcher.call(cards.last["date"]))
      fetched = more_cards.count
      cards.concat more_cards
    end

    cards
  end

  private

  def self.fetch_cards(client, board_id, date = nil)
    raise Trello::Error if client.nil? || board_id.nil? || board_id.empty?

    options = {
      actions: "createCard,updateCard:idList,updateCard:closed,deleteCard",
      fields: :name,
      filter: :all,
      limit: 1000,
      before: date
    }

    client.get("/boards/#{board_id}/cards", options)
  end
end
