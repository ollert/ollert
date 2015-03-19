When(/^I choose to login to Trello$/) do
  on(LandingPage).choose_to_login
  on(LoginPage).login_with Environment.test_username, Environment.test_password
end

When(/^I choose to login to Trello again$/) do
  on(LandingPage).choose_to_login
  on(LoginPage).allow
end

Given(/^I change my mind about connecting with Trello$/) do
  on(LandingPage).lets_get_started
  on(LoginPage).deny
end

Then(/^I should still be on the landing page$/) do
  expect(LandingPage).to be_the_current_page
end

When(/^(then )?I choose to connect with Trello( afterall)?$/) do |_, _|
  on(LandingPage).lets_get_started
  on(LoginPage).login_with Environment.test_username, Environment.test_password
end

When(/^I change my mind about connecting with Trello even after the pitch$/) do
  on(LandingPage).you_hooked_me_lets_get_started
  on(LoginPage).deny
end

When(/^the pitch convinces me to connect with Trello$/) do
  on(LandingPage).you_hooked_me_lets_get_started
  on(LoginPage).login_with Environment.test_username, Environment.test_password
end

When(/^I logout of the application$/) do
  on(LandingPage).logout
end

Then(/^I should be able to see my boards$/) do
  expect(BoardsPage).to be_the_current_page
end