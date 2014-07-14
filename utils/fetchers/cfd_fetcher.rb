class CfdFetcher
  def self.fetch(client, board_id)
    client.get("/boards/#{board_id}",
      {
        actions: "createCard,updateCard:idList,updateList:closed",
        actions_limit: 1000,
        actions_fields: "type,date,data",
        lists: :all,
        list_fields: "name,closed"
      }
    )
  end
end