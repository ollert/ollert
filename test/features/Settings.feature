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
