Then /^I should be redirected to (.*)$/ do |page|
  current_path.should eql path_to page
end

Given(/^the doppelganger user is in the system$/) do
  user = User.new
  user.email = "doppelganger@gmail.com"

  user.save!
end

Given(/^I am editing the settings for the test user$/) do
  page.set_rack_session user: User.find_by(email: Environment.test_username).id

  go_to(SettingsPage) do |screen|
    expect(screen.email).to eq(Environment.test_username)
  end
end

Then(/^there should be (\d+) user(?:s?) in the system$/) do |num_users|
  User.count.should eq num_users.to_i
end

When(/^the val of "(.*?)" is "(.*?)"$/) do |selector, value|
  expect(page.find(selector)[:value]).to eq value
end