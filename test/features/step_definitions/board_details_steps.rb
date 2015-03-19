Then(/^I can drill into the board named "([^"]*)"$/) do |board_name|
  on(BoardsPage).choose board_name
  expect(on(BoardDetails).current_board).to eq(board_name)
end