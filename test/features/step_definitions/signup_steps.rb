Given(/^there are no users in the system$/) do
  User.count.should eq 0
end
