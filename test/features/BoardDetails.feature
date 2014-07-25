@javascript
Feature: BoardDetails
  As a user
  When I select a board
  I would like to see details about the board

Scenario: View board anonymously
  Given I am on the landing page
  And I follow "Connect to Get Started" within ".landing-connect"
  When I authorize with Trello with username "ollerttest" and password "testing ollert"
  Then I should not see "Connecting..."
  And I should not see "Redirecting..."
  And I should be on the boards page
  When I follow "Empty Board"
  Then I should not see "Select a board to view its statistics"
  And I should see "Like what you see? Sign up for a free account to show your support."
  And I should see "Empty Board"

Scenario: View board while logged in
  Given the test user is in the system
  And the test user manually connects to Trello
  And the test user is logged in
  When I go to the boards page
  And I follow "Empty Board"
  Then I should not see "Select a board to view its statistics"
  And I should not see "Like what you see? Sign up for a free account to show your support."
  And I should see "Empty Board"