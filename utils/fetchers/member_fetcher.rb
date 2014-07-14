class MemberFetcher
  def self.fetch(client, token)
    raise Trello::Error if client.nil? || token.nil? || token.empty?
    client.get("/tokens/#{token}/member",
      {
        fields: :username
      }
    )
  end
end