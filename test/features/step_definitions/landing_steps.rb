When(/^I focus on the most recent window$/) do
  page.driver.browser.switch_to.window page.driver.browser.window_handles.last
end
