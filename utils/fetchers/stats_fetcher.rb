class StatsFetcher
  def self.fetch(client, board_id)
    raise Trello::Error if client.nil? || board_id.nil? || board_id.empty?
    client.get("/boards/#{board_id}",
      {
        fields: "name",
        actions: :createCard,
        action_fields: "date,data",
        action_memberCreator: :false,
        action_member: false,
        actions_limit: 1000,
        cards: :visible,
        card_fields: "idList,name,idMembers",
        members: :all,
        member_fields: :fullName,
        lists: :open,
        list_fields: "name,closed",
      }
    )
  end

  def self.fetch_actions(client, board_id, date)
    raise Trello::Error if client.nil? || board_id.nil? || board_id.empty? || date.nil?
    client.get("/boards/#{board_id}/actions",
      {
        filter: :createCard,
        fields: "data,date",
        limit: 1000,
        before: date,
        memberCreator: false,
        member: false
      }
    )
  end
end