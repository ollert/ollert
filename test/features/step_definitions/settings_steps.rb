Given(/^the "(.*?)" field contains "(.*?)"$/) do |field, text|
  find_field(field).value.should eq text
end

Then(/^the test user email should be "(.*?)"$/) do |new_email|
  User.first.email.should eq new_email
end

Then(/^the test user "(.*?)" should be "(.*?)"$/) do |field, value|
  User.first[field.to_sym].should eq value
end
