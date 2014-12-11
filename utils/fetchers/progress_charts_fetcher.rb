class ProgressChartsFetcher
  def self.fetch(client, board_id)
    raise Trello::Error if client.nil? || board_id.nil? || board_id.empty?

    options = {
      actions: "createCard,updateCard:idList,updateCard:closed",
      actions_limit: 1000,
      action_fields: "data,type,date",
      action_memberCreator: :false,
      action_member: false,
      lists: :all,
      list_fields: "name,closed",
      fields: "name"
    }

    client.get("/boards/#{board_id}", options)
  end

  def self.fetch_actions(client, board_id, date)
    raise Trello::Error if client.nil? || board_id.nil? || board_id.empty? || date.nil?

    options = {
      filter: "createCard,updateCard:idList,updateCard:closed",
      fields: "data,type,date",
      limit: 1000,
      before: date,
      memberCreator: false,
      member: false
    }

    client.get("/boards/#{board_id}/actions", options)
  end
end
