class MemberFetcher
  def self.fetch(client, token)
    raise Trello::Error if client.nil? || token.nil? || token.empty?
    JSON.parse(client.get("/tokens/#{token}/member", {fields: "username,gravatarHash,email"}))
  end
end