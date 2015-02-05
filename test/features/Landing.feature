Feature: Landing

@javascript
Scenario: Using the login button
  When I choose to login to Trello
  Then I should be on the boards page

@javascript
Scenario: Deny connecting to Trello - Top of Page
  Given I change my mind about connecting with Trello
  Then I should still be on the landing page

@javascript
Scenario: Allow connecting to Trello - Top of Page
  When I choose to connect with Trello
  Then I should be on the boards page

@javascript
Scenario: Deny connecting to Trello - Bottom of Page
  Given I follow "Connect to Get Started" within ".landing-hook"
  And I press "Deny" on the Trello popup
  Then I should be on the landing page

@javascript
Scenario: Allow connecting to Trello - Bottom of Page
  Given I follow "Connect to Get Started" within ".landing-hook"
  When I authorize with Trello
  Then I should not see "Connecting..."
  And I should not see "Redirecting..."
  And I should be on the boards page

@javascript
Scenario: Allow connecting to Trello after Deny
  Given I follow "Connect to Get Started" within ".landing-connect"
  And I press "Deny" on the Trello popup
  And I follow "Connect to Get Started" within ".landing-connect"
  When I authorize with Trello
  Then I should not see "Connecting..."
  And I should not see "Redirecting..."
  And I should be on the boards page

@javascript
Scenario: Logging out and back in
  Given I am on the landing page
  And I follow "Connect to Get Started" within ".landing-connect"
  When I authorize with Trello
  Then I should not see "Connecting..."
  And I should not see "Redirecting..."
  And I should be on the boards page
  When I click my avatar
  And I follow "Log out"
  Then I should be on the landing page
  And I should see "Successfully logged out"
  Given I press "Log in" within ".navbar-right"
  When I authorize with Trello
  Then I should not see "Connecting..."
  And I should not see "Redirecting..."
  And I should be on the boards page
  And there should be 1 user in the system