class CfdFetcher
  def self.fetch(client, board_id)
    raise Trello::Error if client.nil? || board_id.nil? || board_id.empty?
    client.get("/boards/#{board_id}",
      {
        actions: "createCard,updateCard:idList,updateCard:closed,updateList:closed",
        actions_limit: 1000,
        action_fields: "data,type,date",
        action_memberCreator: :false,
        action_member: false,
        lists: :all,
        list_fields: "name,closed",
        fields: "name"
      }
    )
  end

  def self.fetch_actions(client, board_id, date)
    raise Trello::Error if client.nil? || board_id.nil? || board_id.empty? || date.nil?
    client.get("/boards/#{board_id}/actions",
      {
        filter: "createCard,updateCard:idList,updateCard:closed,updateList:closed",
        fields: "data,type,date",
        limit: 1000,
        before: date,
        memberCreator: false,
        member: false
      }
    )
  end
end