module Trello
  class List < BasicData
    # Archives all the cards of the list
    def archive_all_cards
      client.post("/lists/#{id}/archiveAllCards")
    end
  end
end
