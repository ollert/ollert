When(/^I login using Trello$/) do
  on(LandingPage).get_started
  on(LoginPage).login_with Environment.test_username, Environment.test_password
end

Given(/^I deny Ollert access to my Trello account$/) do
  on(LandingPage).get_started
  on(LoginPage).deny
end

Then(/^I should still be on the landing page$/) do
  expect(LandingPage).to be_the_current_page
end
