require_relative 'action_fetcher'

class ProgressChartsFetcher
  include ActionFetcher

  HARD_CAP = 10000

  def self.fetch(client, board_id)
    raise Trello::Error if client.nil? || board_id.nil? || board_id.empty?

    options = {
      actions: "createCard,updateCard:idList,updateCard:closed",
      actions_limit: 1000,
      action_fields: "data,type,date",
      action_memberCreator: :false,
      action_member: false,
      lists: :open,
      list_fields: :name,
      fields: :name
    }

    include_all_actions(JSON.parse(client.get("/boards/#{board_id}", options)), client, board_id)
  end

  private

  def self.include_all_actions(data, client, board_id)
    fetched = data["actions"].count
    while fetched == 1000 and data["actions"].count < HARD_CAP
      new_actions = JSON.parse(self.fetch_actions(client, board_id,
        {before: data["actions"].last["date"], filter: "createCard,updateCard:idList,updateCard:closed", fields: "data,type,date"}))
      fetched = new_actions.count
      data["actions"].concat new_actions
    end
    data
  end
end
