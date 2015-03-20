@javascript
Feature: BoardDetails
  As a user
  When I select a board
  I would like to see details about the board

Scenario: View board
  When I choose to connect with Trello
  Then I can drill into the board named "Empty Board"
