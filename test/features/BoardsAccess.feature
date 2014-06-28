Feature: Boards Access

Scenario: Visiting boards page without a token
  When I go to the boards page
  Then I should be redirected to the landing page
  And I should see "Log in or connect with Trello to analyze your boards."
