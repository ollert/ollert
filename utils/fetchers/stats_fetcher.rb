require_relative 'action_fetcher'

class StatsFetcher
  include ActionFetcher

  HARD_CAP = 10000

  def self.fetch(client, board_id, show_archived=false)
    raise Trello::Error if client.nil? || board_id.nil? || board_id.empty?

    options = {
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

    if show_archived
      options[:cards] = :all
    end

    include_all_actions(JSON.parse(client.get("/boards/#{board_id}", options)), client, board_id)
  end

  private

  def self.include_all_actions(data, client, board_id)
    fetched = data["actions"].count
    while fetched == 1000 and data["actions"].count < HARD_CAP
      new_actions = JSON.parse(self.fetch_actions(client, board_id,
        {before: data["actions"].last["date"], filter: :createCard, fields: "data,date"}))
      fetched = new_actions.count
      data["actions"].concat new_actions
    end
    data
  end
end
