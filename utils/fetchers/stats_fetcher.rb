class StatsFetcher
  def self.fetch(client, board_id)
    return "{}" if client.nil? || board_id.nil? || board_id.empty?
    client.get("/boards/#{board_id}",
      {
        fields: "name",
        actions: :createCard,
        action_fields: "date,data",
        cards: :all,
        card_fields: "idList,name,idMembers",
        members: :all,
        member_fields: :fullName,
        lists: :open
      }
    )
  end
end