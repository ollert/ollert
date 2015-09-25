class BoardsPage < SitePrism::Page
  set_url '/boards'

  element :drawer_controls, ".drawer-controls a"

  def choose(board_name)
    drawer_controls.click
    wait_for_ajax
    within '.drawer-contents' do
      click_on board_name
    end
  end
end
