@javascript
Feature: View Boards Without Logging In

Background:
  Given the test user has connected to Trello
  And I go to the boards page

Scenario: View names of all available boards
  Then I should see the following boards:
  | organization          | name            |
  | "My Boards"           | Welcome Board"  |
  | "Test Organization 1" | "Test Board #1" |
  | "Test Organization 1" | "Test Board #2" |
