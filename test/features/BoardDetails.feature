@javascript
Feature: BoardDetails
  As a user
  When I select a board
  I would like to see details about the board

Scenario: View board
  When I choose to connect with Trello
  Then I can drill into the board named "Empty Board"

Scenario: Updating the title
  When I am viewing the board "Test Board #1"
  Then the page title reflects the current board I am viewing
