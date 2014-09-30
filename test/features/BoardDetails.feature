@javascript
Feature: BoardDetails
  As a user
  When I select a board
  I would like to see details about the board

Scenario: View board
  Given I am on the landing page
  And I follow "Connect to Get Started" within ".landing-connect"
  When I authorize with Trello
  Then I should not see "Connecting..."
  And I should not see "Redirecting..."
  And I should be on the boards page
  When I follow "Empty Board"
  Then I should not see "Select a board to view its statistics"
  And I should see "Empty Board"