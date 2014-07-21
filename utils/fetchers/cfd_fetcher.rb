require_relative 'fetcher'

class CfdFetcher

  def self.fetch(client, board_id, parameters = {})
    raise Trello::Error if client.nil? || board_id.nil? || board_id.empty?

    options = {
      actions: "createCard,updateCard:idList,updateCard:closed,updateList:closed",
      actions_limit: 1000,
      action_fields: "data,type,date",
      action_memberCreator: :false,
      action_member: false,
      lists: :all,
      list_fields: "name,closed",
      fields: "name"
    }
    Fetcher.merge_date_option!(options, parameters)

    client.get("/boards/#{board_id}", options)
  end

  def self.fetch_actions(client, board_id, date, parameters = {})
    raise Trello::Error if client.nil? || board_id.nil? || board_id.empty? || date.nil?

    options = {
      filter: "createCard,updateCard:idList,updateCard:closed,updateList:closed",
      fields: "data,type,date",
      limit: 1000,
      before: date,
      memberCreator: false,
      member: false
    }
    Fetcher.merge_date_option!(options, parameters)

    client.get("/boards/#{board_id}/actions", options)
  end
end
