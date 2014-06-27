Feature: Landing

Scenario: Navigate to the log in page
  Given I am on the landing page
  And I press "Log in"
  Then I should be on the login page

Scenario: Navigate to the registration page
  Given I am on the landing page
  And I press "Sign Up"
  Then I should be on the register page