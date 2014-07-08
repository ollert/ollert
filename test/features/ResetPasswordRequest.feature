@javascript
Feature: ResetPasswordRequest
  As a user
  When I forget my password
  I need to request a reset

Scenario: Invalid email address
  Given a clear email queue
  And I am on the login page
  When I follow "Forgot password?"
  And I fill in "username" with "garbage@email.com"
  And I press "Submit"
  Then the reset password modal should be closed
  And I should see "No matching user for garbage@email.com. Sign up to create an account."
  And I should have no emails

Scenario: Empty email address
  Given I am on the login page
  When I follow "Forgot password?"
  And I press "Submit"
  Then the reset password modal should be open
  And I should have no emails

Scenario: Email sent successfully
  Given the test user is in the system
  And I am on the login page
  When I follow "Forgot password?"
  And I fill in "username" with "ollertapp@gmail.com"
  And I press "Submit"
  Then the reset password modal should be closed
  And I should see "You should receive an email containing a link to reset your password within a few minutes."
  And "ollertapp@gmail.com" should have 1 email
