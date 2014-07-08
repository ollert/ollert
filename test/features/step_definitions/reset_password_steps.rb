Then(/^the reset password modal should be (open|closed)$/) do |open_str|
  if open_str == 'open'
    expect(page.has_selector?('#resetPasswordModal')).to be true
  else
    expect(page.has_no_selector?('#resetPasswordModal')).to be true
  end
end

Then(/^they should see the password reset link in the email body$/) do
  user = User.find_by(email: "ollertapp@gmail.com")
  url = URI.parse(current_url)
  current_email.default_part_body.to_s.should include(
    "http://#{url.host}:#{url.port}/account/reset/#{user.password_reset.reset_hash}"
  )
end

When /^(?:I|they) follow the password reset link in the email$/ do
  url = URI.parse(current_url)
  visit_in_email "http://#{url.host}:#{url.port}/account/reset/#{User.find_by(email: "ollertapp@gmail.com").password_reset.reset_hash}".gsub("%27", ""),
                 current_email_address
end

When(/^the password reset has expired$/) do
  user = User.find_by(email: "ollertapp@gmail.com")
  user.password_reset.expiration_date = DateTime.now - 1.days
  user.save
end

When /^(?:I|they) follow the password reset link in the email that has already been used$/ do
  user = User.find_by(email: "ollertapp@gmail.com")
  url = URI.parse(current_url)
  link = "http://#{url.host}:#{url.port}/account/reset/#{user.password_reset.reset_hash}"
  user.password_reset = nil
  user.save
  visit_in_email link, current_email_address
end

When /^(?:I|they) follow the password reset link in the email after deleting account$/ do
  user = User.find_by(email: "ollertapp@gmail.com")
  url = URI.parse(current_url)
  link = "http://#{url.host}:#{url.port}/account/reset/#{user.password_reset.reset_hash}"
  user.destroy!
  visit_in_email link, current_email_address
end

When(/^the password reset has been used$/) do
  user = User.find_by(email: "ollertapp@gmail.com")
  user.password_reset = nil
  user.save!
end

When(/^the user is deleted$/) do
  user = User.find_by(email: "ollertapp@gmail.com")
  user.destroy!
end

