Before do
  Mongoid.purge!
end

After do
  user = User.find_by(email: Environment.test_username)
  if !user.nil? && !user.member_token.nil?
    client = Trello::Client.new(
        developer_public_key: Environment.public_key,
        member_token: user.member_token
    )

    client.delete("/tokens/#{user.member_token}")
  end
end
