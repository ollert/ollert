@javascript
Feature: View Boards While Logged In

Background:
  Given I am on the landing page
  And I press "Sign Up"
  And I fill in "email" with "ollertapp@gmail.com"
  And I fill in "password" with "testing ollert"
  And I check "agreed"
  And I press "Sign Me Up!"
  And I follow "Connect to Get Started"
  When I authorize with Trello with username "ollerttest" and password "testing ollert"
  Then I should be on the boards page

Scenario: View names of all available boards
  Then I should see the following boards:
  | organization          | name            |
  | "My Boards"           | Welcome Board"  |
  | "Test Organization 1" | "Test Board #1" |
  | "Test Organization 1" | "Test Board #2" |
