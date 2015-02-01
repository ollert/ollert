require 'dotenv'

AfterConfiguration do |config|
  Dotenv.load File.join(File.dirname(__FILE__), '../../../.env')
end

Before do
  Mongoid.purge!
end

After do
  user = User.find_by(email: ENV['TRELLO_TEST_USERNAME'])
  if !user.nil? && !user.member_token.nil?
    client = Trello::Client.new(
        developer_public_key: ENV['PUBLIC_KEY'],
        member_token: user.member_token
    )

    client.delete("/tokens/#{user.member_token}")
  end
end
