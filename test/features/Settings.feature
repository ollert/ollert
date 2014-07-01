Feature: Settings

Scenario: Accessing while not logged in
  Given I am on the settings page
  Then I should be on the landing page
  And I should see "Hey! You should create an account to do that."

Scenario: Logging out
  Given the test user is in the system
  And the test user is logged in
  And I go to the settings page
  When I press "Log Out"
  Then I should be on the landing page
  And I should see "Come see us again soon!"

@javascript
Scenario: Updating email
  Given the test user is in the system
  And the test user is logged in
  And I go to the settings page
  And the "email" field contains "ollertapp@gmail.com"
  When I fill in "email" with "ollertapp@gmail.co.uk"
  And I press "Update Email"
  Then I should see "Your new email is ollertapp@gmail.co.uk. Use this to log in."
  And the test user email should be "ollertapp@gmail.co.uk"
