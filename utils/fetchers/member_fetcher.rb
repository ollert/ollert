class MemberFetcher
  def self.fetch(client, token)
    client.get("/tokens/#{token}/member",
      {
        fields: :username
      }
    )
  end
end