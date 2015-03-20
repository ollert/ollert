class BoardsPage < SitePrism::Page
  set_url '/boards'

  alias_method :choose, :click_on
end