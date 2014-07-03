Feature: Signup

@javascript
Scenario: Signing up
  Given I am on the signup page
  And there are no users in the system
  When I fill in "email" with "test@email.com"
  And I fill in "password" with "rainbows"
  And I check "I have read and agree to the Terms of Service and Privacy Policy."
  And I press "Sign Me Up!"
  Then I should not see "Registering..."
  And I should not see "Successfully registered. Redirecting..."
  And I should be redirected to the landing page
  And I should see "You're signed up! Connect to Trello to get started."
  And there should be 1 user in the system

@javascript
Scenario: Missing username
  Given I am on the signup page
  And there are no users in the system
  When I fill in "password" with "rainbows"
  And I check "I have read and agree to the Terms of Service and Privacy Policy."
  And I press "Sign Me Up!"
  Then I should be on the signup page
  And there should be 0 users in the system

@javascript
Scenario: Missing password
  Given I am on the signup page
  And there are no users in the system
  When I fill in "email" with "test@email.com"
  And I check "I have read and agree to the Terms of Service and Privacy Policy."
  And I press "Sign Me Up!"
  Then I should be on the signup page
  And there should be 0 users in the system

@javascript
Scenario: Not agreeing to terms
  Given I am on the signup page
  And there are no users in the system
  When I fill in "email" with "test@email.com"
  When I fill in "password" with "rainbows"
  And I press "Sign Me Up!"
  Then I should be on the signup page
  And I should see "Registration failed: Please agree to the terms of service"
  And there should be 0 users in the system

@javascript
Scenario: Username already taken
  Given I am on the signup page
  And the test user is in the system
  When I fill in "email" with "ollertapp@gmail.com"
  And I fill in "password" with "testing ollert"
  And I check "I have read and agree to the Terms of Service and Privacy Policy."
  And I press "Sign Me Up!"
  Then I should be on the signup page
  And I should see "Registration failed: Email is already taken"

@javascript
Scenario: Switching to Login - Link
  Given I am on the signup page
  And there are no users in the system
  When I fill in "email" with "test@email.com"
  And I fill in "password" with "rainbows"
  And I follow "Already have an account? Log in."
  Then the "email" field should contain "test@email.com"
  And the "password" field should contain "rainbows"
  And I should not see "I have read and agree to the Terms of Service and Privacy Policy."
  And I should not see "Already have an account? Log in."
  And I should see "New user? Create an account."

@javascript
Scenario: Switching to Login - Tab
  Given I am on the signup page
  And there are no users in the system
  When I fill in "email" with "test@email.com"
  And I fill in "password" with "rainbows"
  And I follow "Log In"
  Then the "email" field should contain "test@email.com"
  And the "password" field should contain "rainbows"
  And I should not see "I have read and agree to the Terms of Service and Privacy Policy."
  And I should not see "Already have an account? Log in."
  And I should see "New user? Create an account."
