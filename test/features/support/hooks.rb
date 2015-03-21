Before do
  Mongoid.purge!
  on(LandingPage).load
end

Before('@test_user') do
  User.create email: Environment.test_username
end

Before('@existing_lists') do
  (1..4).to_a.reverse.each {|which| TestListBuilder.setup_list("List ##{which}").with_cards("Card #{which}") }
end

After('@existing_lists') do
  TrelloIntegrationHelper.cleanup
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

  TrelloIntegrationHelper.cleanup
end
