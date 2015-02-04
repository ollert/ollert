class LoginPage < SitePrism::Page
  element(:login_with_trello, 'a', text: 'Log in')
  element(:login, 'input#login')
  element(:allow, 'input[value="Allow"]')
  element(:username, 'input[name="user"]')
  element(:password, 'input[name="password"]')

  def login_with(username, password)
    page.within_window(windows.last) do
      login_with_trello.click
      self.username.set username
      self.password.set password
      login.click
      allow.click
      wait_until { current_url =~ /\/boards/i }
    end
  end
end