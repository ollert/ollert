When(/^my work begins with "([^"]*)" and ends with "([^"]*)"$/) do |start_of_work, end_of_work|
  @expected_start_and_end = [start_of_work, end_of_work]
  on(BoardDetails).board_settings
  on(BoardSettings).define_work start_of_work, end_of_work
end

Then(/^my Time Spent in Lists honors my beginning and end of work settings$/) do
  labels = on(BoardDetails).time_spent_labels
  expect([labels.first, labels.last]).to eq(@expected_start_and_end)
end

