class SettingsPage < SitePrism::Page
  set_url '/settings'

  text_field(:email, 'input#email')
  button(:update_email, 'input[value="Update Email"]')
  label(:email_status, '#email-status')
end