@javascript
Feature: Anonymous Boards

Background:
  Given I am on the landing page
  And I follow "Connect to Get Started"
  When I focus on the most recent window
  And I follow "Log in"
  And I fill in "email-login" with "ollerttest"
  And I fill in "password-login" with "testing ollert"
  And I press "Log In"
  And I press "Allow"
  And I focus on the most recent window
  Then I should be on the boards page

Scenario: View names of all available boards
  Then I should see the following boards:
  | organization          | name            |
  | "My Boards"           | Welcome Board"  |
  | "Test Organization 1" | "Test Board #1" |
  | "Test Organization 1" | "Test Board #2" |
