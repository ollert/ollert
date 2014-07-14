class CfdFetcher
  def self.fetch(client, board_id)
    raise Trello::Error if client.nil? || board_id.nil? || board_id.empty?
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