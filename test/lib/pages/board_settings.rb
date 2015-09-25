class BoardSettings < SitePrism::Page
  select_list(:start_of_work, id: 'starting-list')
  select_list(:end_of_work, id: 'ending-list')
  element(:modal, id: 'configure-board-modal')

  link(:apply, text: 'Apply')

  def define_work(start_of, end_of)
    wait_for_ajax
    self.start_of_work = start_of
    self.end_of_work = end_of
    apply
    wait_for_ajax
  end
end
