Feature: Settings

Scenario: Accessing while not logged in
  Given I am on the settings page
  Then I should be on the landing page
  And I should see "Hey! You should create an account to do that."

@javascript
Scenario: Accessing from dropdown
  Given I choose to connect with Trello
  When I click my avatar
  And I follow "Settings"
  Then I should be on the settings page

@javascript @test_user
Scenario: Updating email
  Given I am editing the settings for the test user
  When I change my email address to "ollertapp@gmail.co.uk"
  Then my new email address setting should have been saved

@javascript
Scenario: Connecting to a different Trello account
  Given I choose to connect with Trello
  When I go to the settings page
  Then I am able to connect to an alternative Trello account

@javascript
Scenario: Connecting to Trello with previously-used Trello account
  Given I choose to connect with Trello
  When I go to the settings page
  And there is a copycat user in the system
  When I follow "Connect to a Different Trello Account"
  And I authorize with Trello
  Then I should see "User already exists using that account. Log out to connect with that account."

@javascript @test_user
Scenario: Deny connecting to Trello
  Given I am looking at settings for the test user
  When I follow "Connect to a Different Trello Account"
  And I press "Deny" on the Trello popup
  Then I should see "Connect to a Different Trello Account"

@javascript @test_user
Scenario: Delete account
  Given I am looking at settings for the test user
  When I check "This box verifies that you would like to delete your account when clicking the link below."
  And I press "Delete Account"
  Then I should not see "Account deleted. Redirecting..."
  And I should see "Connect to Get Started"
  And I should be on the landing page
  And there should be 0 users in the system

@javascript @test_user
Scenario: Delete account without checking box
  Given I am looking at settings for the test user
  When I press "Delete Account"
  Then I should see "Delete failed: Check the 'I am sure' checkbox to confirm deletion."
