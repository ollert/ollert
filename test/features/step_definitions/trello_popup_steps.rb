When /^I authorize with Trello with username "(.*?)" and password "(.*?)"$/ do |username, password|
  trello_popup = page.driver.window_handles.last
  page.within_window trello_popup do
    fake_chrome_drivers
    if page.has_content? "Switch Accounts"
      click_link "Switch Accounts"
    else
      click_link "Log in"
    end
    
    fill_in "email-login", with: username
    fill_in "password-login", with: password
    click_button "Log In"
    click_button "Allow"
  end
end

When /^I press "(.*?)" on the Trello popup$/ do |button|
  trello_popup = page.driver.window_handles.last
  page.within_window trello_popup do
    click_button button
  end
end

Given(/^the test user manually connects to Trello$/) do
  page.set_rack_session user: User.find_by(email: "ollertapp@gmail.com").id
  visit path_to("the settings page")

  click_link("Connect with Trello")

  trello_popup = page.driver.window_handles.last
  page.within_window trello_popup do
    fake_chrome_drivers
    if page.has_content? "Switch Accounts"
      click_link "Switch Accounts"
    else
      click_link "Log in"
    end

    fill_in "email-login", with: "ollerttest"
    fill_in "password-login", with: "testing ollert"
    click_button "Log In"
    click_button "Allow"
  end

  page.should have_content("Successfully connected")
end

def fake_chrome_drivers
  page.driver.header(
    "User-Agent",
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/34.0.1847.116 Chrome/34.0.1847.116 Safari/537.36"
    )
end