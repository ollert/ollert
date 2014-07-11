Feature: Boards Access

Scenario: Visiting boards page without a token
  When I go to the boards page
  Then I should be redirected to the landing page
  And I should see "There's something wrong with the Trello connection. Please re-establish the connection."
