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

When(/^I see the HTML$/) do
  puts page.html
end
