require 'json'

class LabelCountFetcher
  def self.fetch(client, board_id)
    raise Trello::Error if client.nil? || board_id.nil? || board_id.empty?
    JSON.parse(client.get("/boards/#{board_id}/labels", {fields: "color,name,uses", limit: 100}))
  end
end
