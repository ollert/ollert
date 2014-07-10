require 'trello'

class BoardFetcher
  def self.fetch(client, token)
    client.get("/members/#{token.member_id}/boards", {filter: :open, fields: :name, organization: true})
  end
end