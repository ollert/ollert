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
  And the test user "email" should be "ollertapp@gmail.co.uk"

@javascript
Scenario: Updating email to email already in use
  Given the test user is in the system
  And the doppelganger user is in the system
  And the test user is logged in
  And I go to the settings page
  And the "email" field contains "ollertapp@gmail.com"
  When I fill in "email" with "doppelganger@gmail.com"
  And I press "Update Email"
  Then I should see "Save failed: Email is already taken"
  And the test user "email" should be "ollertapp@gmail.com"

@javascript
Scenario: Updating password
  Given the test user is in the system
  And the test user is logged in
  And I go to the settings page
  When I fill in "current_password" with "testing ollert"
  And I fill in "new_password" with "new password"
  And I fill in "confirm_password" with "new password"
  And I press "Update Password"
  Then I should see "Password updated."
  And the "current_password" field should contain ""
  And the "new_password" field should contain ""
  And the "confirm_password" field should contain ""

@javascript
Scenario: Updating password with wrong current password
  Given the test user is in the system
  And the test user is logged in
  And I go to the settings page
  When I fill in "current_password" with "bad password"
  And I fill in "new_password" with "new password"
  And I fill in "confirm_password" with "new password"
  And I press "Update Password"
  Then I should see "Save failed: Current password entered incorrectly."

@javascript
Scenario: Updating password with non-matching new password
  Given the test user is in the system
  And the test user is logged in
  And I go to the settings page
  When I fill in "current_password" with "testing ollert"
  And I fill in "new_password" with "new password"
  And I fill in "confirm_password" with "different password"
  And I press "Update Password"
  Then I should see "Save failed: New password fields do not match."

@javascript
Scenario: Disconnecting from Trello
  Given the test user is in the system
  And the test user is logged in
  And I go to the settings page
  When I follow "Disconnect Trello user ollerttest"
  Then I should see "Successfully disconnected."
  And I should see "Connect with Trello"
  And I should not see "Disconnect Trello user ollerttest"
  And the test user "trello_name" should be nil
  And the test user "member_token" should be nil

@javascript
Scenario: Connecting to Trello
  Given the test user is in the system
  And the test user "trello_name" is nil
  And the test user "member_token" is nil
  And the test user is logged in
  And I go to the settings page
  When I follow "Connect with Trello"
  And I authorize with Trello with username "ollerttest" and password "testing ollert"
  Then I should see "Successfully connected."
  And I should see "Disconnect Trello user ollerttest"
  And I should not see "Connect with Trello"
  And the test user "trello_name" should be "ollerttest"

@javascript
Scenario: Deny connecting to Trello
  Given the test user is in the system
  And the test user "trello_name" is nil
  And the test user "member_token" is nil
  And the test user is logged in
  And I go to the settings page
  When I follow "Connect with Trello"
  And I press "Deny" on the Trello popup
  Then I should see "Connect with Trello"

@javascript
Scenario: Delete account
  Given the test user is in the system
  And the test user is logged in
  And I go to the settings page
  When I check "This box verifies that you would like to delete your account when clicking the link below."
  And I press "Delete Account"
  Then I should not see "Account deleted. Redirecting..."
  And I should see "Connect to Get Started"
  And I should be on the landing page
  And there should be 0 users in the system

@javascript
Scenario: Delete account without checking box
  Given the test user is in the system
  And the test user is logged in
  And I go to the settings page
  When I press "Delete Account"
  Then I should see "Delete failed: Check the 'I am sure' checkbox to confirm deletion."
