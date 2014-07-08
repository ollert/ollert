@javascript
Feature: ResetPassword
  As a user
  When I forget my password
  And I receive an email
  I want to reset my password

Background:
  Given a clear email queue
  And the test user is in the system
  And the test user "member_token" is nil
  And I am on the login page
  When I follow "Forgot password?"
  And I fill in "username" with "ollertapp@gmail.com"
  And I press "Submit"
  Then the reset password modal should be closed
  And "ollertapp@gmail.com" should receive an email

Scenario: Email contents should be accurate
  When "ollertapp@gmail.com" opens the email
  Then they should see the email delivered from "Ollert Help Desk <noreply@ollertapp.com>"
  And they should see "Ollert Password Reset Notification" in the email subject
  And they should see "Username: ollertapp@gmail.com" in the email body
  And they should see "Time:" in the email body
  And they should see "IP address: 127.0.0.1" in the email body
  And they should see the password reset link in the email body

Scenario: Successfully reset password
  When "ollertapp@gmail.com" opens the email
  And they follow the password reset link in the email
  And the val of "#email" is "ollertapp@gmail.com"
  When I fill in "password" with "new password"
  And I press "Reset Password"
  Then I should not see "Password updated. Redirecting..."
  And I should be on the landing page

Scenario: Follow expired password reset link
  When "ollertapp@gmail.com" opens the email
  And the password reset has expired
  And they follow the password reset link in the email
  Then I should be on the login page
  And I should see "Password reset time period has expired. Please try again."

Scenario: Follow previously used password reset link
  When "ollertapp@gmail.com" opens the email
  And they follow the password reset link in the email that has already been used
  Then I should be on the login page
  And I should see "Invalid reset hash. Please try again."

Scenario: Follow password reset link for deleted user
  When "ollertapp@gmail.com" opens the email
  And they follow the password reset link in the email after deleting account
  Then I should be on the login page
  And I should see "Invalid reset hash. Please try again."


Scenario: Submit after expiration
  When "ollertapp@gmail.com" opens the email
  And they follow the password reset link in the email
  And the val of "#email" is "ollertapp@gmail.com"
  When I fill in "password" with "new password"
  And the password reset has expired
  And I press "Reset Password"
  Then I should be on the login page
  And I should see "Password reset time period has expired. Please try again."

Scenario: Submit after using elsewhere
  When "ollertapp@gmail.com" opens the email
  And they follow the password reset link in the email
  And the val of "#email" is "ollertapp@gmail.com"
  When I fill in "password" with "new password"
  And the password reset has been used
  And I press "Reset Password"
  Then I should be on the login page
  And I should see "Password reset time period has expired. Please try again."

Scenario: Submit after user deleted
  When "ollertapp@gmail.com" opens the email
  And they follow the password reset link in the email
  And the val of "#email" is "ollertapp@gmail.com"
  When I fill in "password" with "new password"
  And the user is deleted
  And I press "Reset Password"
  Then I should be on the login page
  And I should see "Password reset time period has expired. Please try again."
