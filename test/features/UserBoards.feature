@javascript @token
Feature: View Boards While Logged In

Background:
  Given the test user is in the system
  And the test user manually connects to Trello
  And the test user is logged in
  And I go to the boards page
  Then I should be on the boards page

Scenario: View names of all available boards
  Then I should see the following boards:
  | organization          | name            |
  | "My Boards"           | Welcome Board"  |
  | "My Boards"           | "Empty Board"   |
  | "Test Organization 1" | "Test Board #1" |
  | "Test Organization 1" | "Test Board #2" |
