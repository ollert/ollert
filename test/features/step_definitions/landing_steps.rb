When(/^I choose to login to Trello$/) do
  on(LandingPage).choose_to_login
  on(LoginPage).login_with Environment.test_username, Environment.test_password
end

Given(/^I change my mind about connecting with Trello$/) do
  on(LandingPage).lets_get_started
  on(LoginPage).deny
end

Then(/^I should still be on the landing page$/) do
  expect(LandingPage).to be_the_current_page
end

When(/^I choose to connect with Trello$/) do
  on(LandingPage).lets_get_started
  on(LoginPage).login_with Environment.test_username, Environment.test_password
end
