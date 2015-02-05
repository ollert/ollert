class LoginPage < SitePrism::Page
  element(:login_with_trello, 'a', text: 'Log in')
  element(:login, 'input#login')

  element(:allow_button, 'input[value="Allow"]')
  element(:deny_button, 'input.deny')

  element(:username, 'input[name="user"]')
  element(:password, 'input[name="password"]')

  def login_with(username, password)
    in_trello_popup do
      login_with_trello.click
      self.username.set username
      self.password.set password
      login.click
      allow_button.click
    end
    wait_until { current_url =~ /\/boards/i }
  end

  def allow
    in_trello_popup { allow_button.click }
  end

  def deny
    in_trello_popup { deny_button.click }
  end

  private
  def in_trello_popup(&block)
    page.within_window(windows.last, &block)
  end
end