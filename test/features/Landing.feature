Feature: Landing

Background:
  Given I am on the landing page

Scenario: Navigate to the log in page
  Given I press "Log in" within ".navbar-right"
  Then I should be on the login page

Scenario: Navigate to the registration page
  Given I press "Sign Up" within ".navbar-right"
  Then I should be on the register page

@javascript
Scenario: Deny connecting to Trello - Top of Page
  Given I follow "Connect to Get Started" within ".landing-connect"
  And I press "Deny" on the Trello popup
  Then I should be on the landing page

@javascript
Scenario: Allow connecting to Trello - Top of Page
  Given I follow "Connect to Get Started" within ".landing-connect"
  When I authorize with Trello with username "ollerttest" and password "testing ollert"
  Then I should not see "Connecting..."
  And I should not see "Redirecting..."
  And I should be on the boards page

@javascript
Scenario: Deny connecting to Trello - Bottom of Page
  Given I follow "Connect to Get Started" within ".landing-hook"
  And I press "Deny" on the Trello popup
  Then I should be on the landing page

@javascript
Scenario: Allow connecting to Trello - Bottom of Page
  Given I follow "Connect to Get Started" within ".landing-hook"
  When I authorize with Trello with username "ollerttest" and password "testing ollert"
  Then I should not see "Connecting..."
  And I should not see "Redirecting..."
  And I should be on the boards page

@javascript
Scenario: Allow connecting to Trello after Deny
  Given I follow "Connect to Get Started" within ".landing-connect"
  And I press "Deny" on the Trello popup
  And I follow "Connect to Get Started" within ".landing-connect"
  When I authorize with Trello with username "ollerttest" and password "testing ollert"
  Then I should not see "Connecting..."
  And I should not see "Redirecting..."
  And I should be on the boards page
