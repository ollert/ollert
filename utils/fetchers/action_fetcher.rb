module ActionFetcher
  def fetch_actions(client, board_id, overrides)
    raise Trello::Error if client.nil? || board_id.nil? || board_id.empty?

    options = {
      filter: :createCard,
      fields: "data,date",
      limit: 1000,
      before: date,
      memberCreator: false,
      member: false
    }.merge(overrides)

    client.get("/boards/#{board_id}/actions", options)
  end
end