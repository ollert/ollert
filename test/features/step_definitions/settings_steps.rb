Given(/^the "(.*?)" field contains "(.*?)"$/) do |field, text|
  find_field(field).value.should eq text
end

Given(/^the test user "(.*?)" is nil$/) do |field|
  user = User.first
  user[field.to_sym] = nil
  user.save!
end

Given(/^the test user "(.*?)" is "(.*?)"$/) do |field, value|
  user = User.first
  user[field.to_sym] = value
  user.save!
end

Then(/^the test user email should be "(.*?)"$/) do |new_email|
  User.first.email.should eq new_email
end

Then(/^the test user "(.*?)" should be "(.*?)"$/) do |field, value|
  User.first[field.to_sym].should eq value
end

Then(/^the test user "(.*?)" should be nil$/) do |field|
  User.first[field.to_sym].should be_nil
end

Given(/^the email field contains the test email address$/) do
  find_field("email").value.should eq Environment.test_username
end

Given(/^there is a copycat user in the system$/) do
  original = User.first
  trelloId = original.trello_id

  original.trello_id = nil
  original.save

  User.create trello_id: trelloId
end

When(/^I click my avatar$/) do
  find(".settings-link").click
end

Then(/^I am able to connect to an alternative Trello account$/) do
  click_link('Connect to a Different Trello Account')
  step 'I authorize with Trello'
  expect(User.first[:trello_name]).to eq(Environment.test_display_name)
end