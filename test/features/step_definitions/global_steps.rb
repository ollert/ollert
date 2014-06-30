Then /^I should be redirected to (.*)$/ do |page|
  current_path.should eql path_to page
end

When /^I authorize with Trello with username "(.*?)" and password "(.*?)"$/ do |username, password|
  # focus on Trello window
  page.driver.browser.switch_to.window page.driver.browser.window_handles.last

  if page.has_content? "Switch Accounts"
    click_link "Switch Accounts"
  else
    click_link "Log in"
  end
  
  fill_in "email-login", with: username
  fill_in "password-login", with: password
  click_button "Log In"
  click_button "Allow"

  # focus back to Ollert
  page.driver.browser.switch_to.window page.driver.browser.window_handles.last
end
