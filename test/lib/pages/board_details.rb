class BoardDetails < SitePrism::Page
  button(:board_settings, 'button[data-target="#configure-board-modal"]')

  label(:current_board, '#board-name')

  elements(:time_spent_spans, '#time-in-lists-container .highcharts-xaxis-labels text')

  def time_spent_labels
    list_items = nil
    wait_until do
      list_items = time_spent_spans.map(&:text)
      !list_items.empty?
    end

    list_items
  end
end
