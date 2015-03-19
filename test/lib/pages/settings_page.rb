class SettingsPage < SitePrism::Page
  set_url '/settings'

  text_field(:email, 'input#email')
  label(:email_status, '#email-status')
  button(:save_email, 'input[value="Update Email"]')

  button(:connect_with_a_different_account, '#trello-connect')
  label(:trello_connect_status, '#trello-connect-status')

  checkbox(:confirm_delete, '#i-am-sure')
  button(:delete_account, '#delete-account-button')
  label(:delete_status, '#delete-account-status')

  def update_email
    save_email
    wait_until { email_status != 'Saving...' }
  end

  alias_method :orig_connect, :connect_with_a_different_account
  def connect_with_a_different_account(&block)
    orig_connect
    block.call(self) if block
    allow_alternative_account unless block
  end

  private
  def allow_alternative_account
    LoginPage.new.allow
    wait_until { trello_connect_status != 'Saving...' }
  end
end