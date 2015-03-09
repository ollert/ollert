class SettingsPage < SitePrism::Page
  set_url '/settings'

  text_field(:email, 'input#email')
  label(:email_status, '#email-status')
  button(:save_email, 'input[value="Update Email"]')

  checkbox(:confirm_delete, '#i-am-sure')
  button(:delete_account, '#delete-account-button')

  def update_email
    save_email
    wait_until { email_status != 'Saving...' }
  end
end