@javascript
Feature: View Boards Without Logging In

Scenario: View names of all available boards
  Given I am on the landing page
  And I follow "Connect to Get Started" within ".landing-connect"
  When I authorize with Trello
  Then I should not see "Connecting..."
  And I should not see "Redirecting..."
  And I should be on the boards page
  Then I should see the following boards:
  | organization        | name          |
  | My Boards           | Welcome Board |
  | My Boards           | Empty Board   |
  | Test Organization 1 | Test Board #1 |
  | Test Organization 1 | Test Board #2 |


Scenario: Visiting boards page without being connected
  When I go to the boards page
  Then I should be redirected to the landing page
  And I should see "Hey! You should create an account to do that."