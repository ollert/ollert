Feature: Settings

Scenario: Accessing while not logged in
  Given I am on the settings page
  Then I should be on the landing page
  And I should see "Hey! You should create an account to do that."

@javascript
Scenario: Accessing from dropdown
  When I choose to connect with Trello
  Then I can get to my settings by selecting my avatar

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
  Given I am looking at the settings for my account
  But there is a copycat user in the system
  When I connect with the Trello account that has a copycat
  Then I am notified that the user account already exists

@javascript @test_user
Scenario: Deny connecting to Trello
  Given I am looking at settings for the test user
  When I first choose to connect with a different Trello Account, but change my mind
  Then I should remain on the settings page

@javascript @test_user
Scenario: Delete account
  Given I am looking at settings for the test user
  When I confirm that I want to delete my account
  Then I am redirected to login after my account is deleted

@javascript @test_user
Scenario: Delete account without checking box
  Given I am looking at settings for the test user
  When I choose to delete my account without confirming
  Then I should be reminded that I need to confirm the deletion first
