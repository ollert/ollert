class LandingPage < SitePrism::Page
  set_url '/'
  element :login_top, '.navbar-right input[value="Log in"]'
  element :connect, '.landing-connect a.connect-btn'
  element :hooked_connect, '.landing-hook a.btn-primary'
  element :settings, '.settings-link'
  element :logout_link, 'a', text: 'Log out'

  def choose_to_login
    login_top.click
  end

  def lets_get_started
    connect.click
  end

  def you_hooked_me_lets_get_started
    hooked_connect.click
  end

  def logout
    settings.click
    logout_link.click
  end
end