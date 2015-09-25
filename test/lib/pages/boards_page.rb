class BoardsPage < SitePrism::Page
  set_url '/boards'

  element :drawer_controls, ".drawer-controls a"
  element :board_list_first_item, "#config-drawer-board-list li:first-child"

  # alias_method :choose, :click_on

  def choose(board_name)
    # wait_for_board_list_first_item 10
    # drawer_controls.click
    click_on board_name
  end
end
