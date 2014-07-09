Feature: Login

@javascript
Scenario: Logging in - user has boards
  Given I am on the login page
  And the test user is in the system
  When I fill in "email" with "ollertapp@gmail.com"
  And I fill in "password" with "testing ollert"
  And I press "Log In"
  And I wait 3 seconds
  Then I should be on the boards page

@javascript
Scenario: Logging in - user has no boards
  Given I am on the login page
  And the test user is in the system
  And the test user "member_token" is nil
  When I fill in "email" with "ollertapp@gmail.com"
  And I fill in "password" with "testing ollert"
  And I press "Log In"
  Then I should see "Connect to Get Started"
  And I should be on the landing page

@javascript
Scenario: Missing username
  Given I am on the login page
  And the test user is in the system
  When I fill in "password" with "rainbows"
  And I press "Log In"
  Then I should be on the login page

@javascript
Scenario: Missing password
  Given I am on the login page
  And the test user is in the system
  When I fill in "email" with "test@email.com"
  And I press "Log In"
  Then I should be on the login page

@javascript
Scenario: Wrong password
  Given I am on the login page
  And the test user is in the system
  When I fill in "email" with "ollertapp@gmail.com"
  And I fill in "password" with "bad password"
  And I press "Log In"
  Then I should be on the login page
  And I should see "Login failed: Incorrect password"

@javascript
Scenario: No such user
  Given I am on the login page
  When I fill in "email" with "ollertapp@gmail.com"
  And I fill in "password" with "testing ollert"
  And I press "Log In"
  Then I should be on the login page
  And I should see "Login failed: Incorrect email"

@javascript
Scenario: Switching to Signup - Link
  Given I am on the login page
  And the test user is in the system
  When I fill in "email" with "test@email.com"
  And I fill in "password" with "rainbows"
  And I follow "New user? Create an account."
  Then the "email" field should contain "test@email.com"
  And the "password" field should contain "rainbows"
  And I should not see "New user? Create an account."
  And I should see "I have read and agree to the Terms of Service and Privacy Policy."
  And I should see "Already have an account? Log in."

@javascript
Scenario: Switching to Signup - Tab
  Given I am on the login page
  When I fill in "email" with "test@email.com"
  And I fill in "password" with "rainbows"
  And I follow "Sign Up"
  Then the "email" field should contain "test@email.com"
  And the "password" field should contain "rainbows"
  And I should not see "New user? Create an account."
  And I should see "I have read and agree to the Terms of Service and Privacy Policy."
  And I should see "Already have an account? Log in."
