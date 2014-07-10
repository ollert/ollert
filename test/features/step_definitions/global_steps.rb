Then /^I should be redirected to (.*)$/ do |page|
  current_path.should eql path_to page
end

Given(/^the test user has connected to Trello$/) do
  page.set_rack_session token: "37f9f5baf86b99e50cecf02b66d363ab642138d7188e580fce4243cd0f101df2"
end

Given(/^the test user is in the system$/) do
  user = User.new
  user.email = "ollertapp@gmail.com"
  user.password = "testing ollert"
  user.trello_name = "ollerttest"
  user.member_token = "37f9f5baf86b99e50cecf02b66d363ab642138d7188e580fce4243cd0f101df2"

  user.save!
end

Given(/^the doppelganger user is in the system$/) do
  user = User.new
  user.email = "doppelganger@gmail.com"
  user.password = "password"

  user.save!
end

Given(/^the test user is logged in$/) do
  page.set_rack_session user: User.find_by(email: "ollertapp@gmail.com").id
end

Then(/^there should be (\d+) user(?:s?) in the system$/) do |num_users|
  User.count.should eq num_users.to_i
end

When(/^the val of "(.*?)" is "(.*?)"$/) do |selector, value|
  expect(page.find(selector)[:value]).to eq value
end
