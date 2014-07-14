require 'trello'

class BoardFetcher
  def self.fetch(client, member_id)
    client.get("/members/#{member_id}/boards", {filter: :open, fields: :name, organization: true})
  end
end