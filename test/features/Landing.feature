Feature: Landing

@javascript
Scenario: Using the login button
  When I choose to login to Trello
  Then I should be able to see my boards

@javascript
Scenario: Deny connecting to Trello - Top of Page
  Given I change my mind about connecting with Trello
  Then I should still be on the landing page

@javascript
Scenario: Allow connecting to Trello - Top of Page
  When I choose to connect with Trello
  Then I should be able to see my boards

@javascript
Scenario: Deny connecting to Trello - Bottom of Page
  When I change my mind about connecting with Trello even after the pitch
  Then I should still be on the landing page

@javascript
Scenario: Allow connecting to Trello - Bottom of Page
  When the pitch convinces me to connect with Trello
  Then I should be able to see my boards

@javascript
Scenario: Allow connecting to Trello after Deny
  Given I change my mind about connecting with Trello
  But then I choose to connect with Trello afterall
  Then I should be able to see my boards

@javascript
Scenario: Logging out and back in
  Given I choose to connect with Trello
  When I logout of the application
  But I choose to login to Trello again
  Then there should be 1 user in the system
