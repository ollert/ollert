class LandingPage < SitePrism::Page
  include OllertTest::Navigation

  set_url '/'
  element :connect, '.landing-connect .connect-btn'

  def get_started
    connect.click
  end
end