class LandingPage < SitePrism::Page
  set_url '/'

  button(:choose_to_login, '.navbar-right input[value="Log in"]')
  button(:lets_get_started, '.landing-connect a.connect-btn')
  button(:you_hooked_me_lets_get_started, '.landing-hook a.btn-primary')

  link(:settings, 'a.settings-link')
  link(:logout, text: 'Log out')

  def logout
    settings
    logout_element.click
  end
end