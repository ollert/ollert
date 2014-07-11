@javascript
Feature: View Boards Without Logging In

Background:
  Given I am on the landing page
  And I follow "Connect to Get Started"
  When I authorize with Trello with username "ollerttest" and password "testing ollert"
  Then I should not see "Connecting..."
  And I should not see "Redirecting..."
  And I should be on the boards page

Scenario: View names of all available boards
  Then I should see the following boards:
  | organization          | name            |
  | "My Boards"           | Welcome Board"  |
  | "Test Organization 1" | "Test Board #1" |
  | "Test Organization 1" | "Test Board #2" |
