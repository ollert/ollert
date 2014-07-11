Then /^I should be redirected to (.*)$/ do |page|
  current_path.should eql path_to page
end

Given(/^the test user is in the system$/) do
  user = User.new
  user.email = "ollertapp@gmail.com"
  user.password = "testing ollert"

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
