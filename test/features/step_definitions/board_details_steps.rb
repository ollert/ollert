Then(/^I can drill into the board named "([^"]*)"$/) do |board_name|
  on(BoardsPage).choose board_name
  expect(on(BoardDetails).current_board).to eq(board_name)
end

When(/^I am viewing the board "([^"]*)"$/) do |board_name|
  @expected_board_title = board_name
  navigate_to(BoardsPage, using: :boards_route).choose board_name
end

Then(/^the page title reflects the current board I am viewing$/) do
  expect(on(BoardDetails).title).to eq "Ollert - #{@expected_board_title} Board"
end
