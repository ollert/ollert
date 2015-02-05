class LandingPage < SitePrism::Page
  set_url '/'
  element :login_top, '.navbar-right input[value="Log in"]'
  element :connect, '.landing-connect a.connect-btn'

  def choose_to_login
    login_top.click
  end

  def lets_get_started
    connect.click
  end
end