When(/^my work begins with "([^"]*)" and ends with "([^"]*)"$/) do |start_of_work, end_of_work|
  on(BoardDetails).board_settings
  on(BoardSettings).define_work start_of_work, end_of_work
end

Then(/^my Time Spent in Lists should start with "([^"]*)" and end with "([^"]*)"$/) do |start_of_work, prior_to_end_of_work|
  labels = on(BoardDetails).time_spent_labels
  expect([labels.first, labels.last]).to eq([start_of_work, prior_to_end_of_work])
end

Given(/^some of my cards have been archived$/) do
  cards_not_in_three = TrelloIntegrationHelper.open_cards.select { |card| card.list.name != 'List #3' }
  cards_not_in_three.each(&:close!)

  @expected_labels = %w(List\ #3)
end

When(/^I refresh my view$/) do
  on(BoardDetails).refresh
end

Then(/^my Time Spent in Lists should reflect nothing, since all my cards are archived$/) do
  expect(on(BoardDetails).time_spent_labels).to eq @expected_labels
end
