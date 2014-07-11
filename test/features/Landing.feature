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
Scenario: Deny connecting to Trello - Top of Page
  Given I follow "Connect to Get Started"
  And I press "Deny" on the Trello popup
  Then I should be on the landing page

@javascript
Scenario: Allow connecting to Trello - Top of Page
  Given I follow "Connect to Get Started"
  When I authorize with Trello with username "ollerttest" and password "testing ollert"
  Then I should not see "Connecting..."
  And I should not see "Redirecting..."
  And I should be on the boards page

@javascript
Scenario: Deny connecting to Trello - Bottom of Page
  Given I follow "Get Started Now"
  And I press "Deny" on the Trello popup
  Then I should be on the landing page

@javascript
Scenario: Allow connecting to Trello - Bottom of Page
  Given I follow "Get Started Now"
  When I authorize with Trello with username "ollerttest" and password "testing ollert"
  Then I should not see "Connecting..."
  And I should not see "Redirecting..."
  And I should be on the boards page

@javascript
Scenario: Allow connecting to Trello after Deny
  Given I follow "Connect to Get Started"
  And I press "Deny" on the Trello popup
  And I follow "Connect to Get Started"
  When I authorize with Trello with username "ollerttest" and password "testing ollert"
  Then I should not see "Connecting..."
  And I should not see "Redirecting..."
  And I should be on the boards page
