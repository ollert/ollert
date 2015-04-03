When(/^my work begins with "([^"]*)" and ends with "([^"]*)"$/) do |start_of_work, end_of_work|
  on(BoardDetails).board_settings
  on(BoardSettings).define_work start_of_work, end_of_work
end

Then(/^my Time Spent in Lists should start with "([^"]*)" and end with "([^"]*)"$/) do |start_of_work, prior_to_end_of_work|
  labels = on(BoardDetails).time_spent_labels
  expect([labels.first, labels.last]).to eq([start_of_work, prior_to_end_of_work])
end
