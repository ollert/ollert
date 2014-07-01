Given(/^the "(.*?)" field contains "(.*?)"$/) do |field, text|
  find_field(field).value.should eq text
end

Then(/^the test user email should be "(.*?)"$/) do |new_email|
  User.first.email.should eq new_email
end