@javascript
Feature: View Boards Without Logging In

Scenario: View names of all available boards
  When I choose to connect with Trello
  Then I should see the following boards:
  | organization        | name          |
  | My Boards           | Welcome Board |
  | My Boards           | Empty Board   |
  | Test Organization 1 | Test Board #1 |
  | Test Organization 1 | Test Board #2 |


Scenario: Visiting boards page without being connected
  When I attempt to view my boards without logging in first
  Then I should be told that I have to login before I can do that
