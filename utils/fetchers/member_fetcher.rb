class MemberFetcher
  def self.fetch(client, token)
    return "{}" if client.nil? || token.nil? || token.empty?
    client.get("/tokens/#{token}/member",
      {
        fields: :username
      }
    )
  end
end