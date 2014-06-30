Feature: Landing

Background:
  Given I am on the landing page

Scenario: Navigate to the log in page
  Given I press "Log in"
  Then I should be on the login page

Scenario: Navigate to the registration page
  Given I press "Sign Up"
  Then I should be on the register page

@javascript
Scenario: Deny connecting to Trello
  Given I follow "Connect to Get Started"
  When I focus on the most recent window
  And I press "Deny"
  And I focus on the most recent window
  Then I should be on the landing page

@javascript
Scenario: Allow connecting to Trello
  Given I follow "Connect to Get Started"
  When I authorize with Trello with username "ollerttest" and password "testing ollert"
  Then I should be on the boards page