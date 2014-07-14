class StatsFetcher
  def self.fetch(client, board_id)
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