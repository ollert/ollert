When(/^I attempt to view my settings without logging in first$/) do
  on(SettingsPage).load
end

Given(/^I am looking at settings for the test user$/) do
  page.set_rack_session user: User.find_by(email: Environment.test_username).id
  go_to(SettingsPage)
end

Given(/^there is a copycat user in the system$/) do
  original = User.first
  trelloId = original.trello_id

  original.trello_id = nil
  original.save

  User.create trello_id: trelloId
end

Then(/^I can get to my settings by selecting my avatar$/) do
  on(LandingPage) do |screen|
    screen.settings
    screen.click_link 'Settings'
  end
  expect(SettingsPage).to be_the_current_page
end

Then(/^I am able to connect to an alternative Trello account$/) do
  on(SettingsPage).connect_with_a_different_account
  expect(User.first[:trello_name]).to eq(Environment.test_display_name)
end

When(/^I change my email address to "([^"]*)"$/) do |new_email|
  @new_email = new_email

  on(SettingsPage) do |screen|
    screen.email = @new_email
    screen.update_email
  end
end

Then(/^my new email address setting should have been saved$/) do
  expect(on(SettingsPage).email_status).to eq("Your new email is #{@new_email}. Use this to log in.")
  expect(User.first[:email]).to eq(@new_email)
end

When(/^I confirm that I want to delete my account$/) do
  on(SettingsPage) do |screen|
    screen.confirm_delete = true
    screen.delete_account
  end
end

Then(/^I am redirected to login after my account is deleted$/) do
  expect(LandingPage).to be_the_current_page
  expect(User.count).to be_zero
end

When(/^I choose to delete my account without confirming$/) do
  on(SettingsPage).delete_account
end

Then(/^I should be reminded that I need to confirm the deletion first$/) do
  expect(on(SettingsPage).delete_status).to include "Delete failed: Check the 'I am sure' checkbox to confirm deletion."
end

Given(/^I am looking at the settings for my account$/) do
  navigate_to(SettingsPage).load
end

When(/^I connect with the Trello account that has a copycat$/) do
  on(SettingsPage).connect_with_a_different_account
end

Then(/^I am notified that the user account already exists$/) do
  expect(on(SettingsPage).trello_connect_status).to include 'User already exists using that account. Log out to connect with that account.'
end

When(/^I first choose to connect with a different Trello Account, but change my mind$/) do
  on(SettingsPage).connect_with_a_different_account { LoginPage.new.deny }
end

Then(/^I should remain on the settings page$/) do
  expect(SettingsPage).to be_the_current_page
end

When(/^I go to view my settings$/) do
  on(SettingsPage).load
end
