When(/^I login using Trello$/) do
  on(LandingPage).get_started
  on(LoginPage).login_with Environment.test_username, Environment.test_password
end