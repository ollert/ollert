class LoginPage < SitePrism::Page
  link(:login_with_trello, text: 'Log in')
  button(:login, 'input#login')

  button(:allow, 'input[value="Allow"]')
  button(:deny, 'input.deny')

  text_field(:username, 'input[name="user"]')
  text_field(:password, 'input[name="password"]')

  def login_with(username, password)
    in_trello_popup do
      login_with_trello
      self.username = username
      self.password = password
      login
      allow
    end
    wait_until { current_url =~ /\/boards/i }
  end

  def allow
    in_trello_popup { allow_element.click }
  end

  def deny
    in_trello_popup { deny_element.click }
  end

  private
  def in_trello_popup(&block)
    page.within_window(windows.last, &block)
  end
end