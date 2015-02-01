When /^I authorize with Trello$/ do
  expect(Environment.test_username).to_not be_nil
  expect(Environment.test_password).to_not be_nil

  trello_popup = windows.last
  page.within_window trello_popup do
    fake_chrome_drivers
    if page.has_content? "Switch Accounts"
      click_link "Switch Accounts"
    else
      click_link "Log in"
    end

    fill_in "user", with: Environment.test_username
    fill_in "password", with: Environment.test_password
    click_button "Log In"
    click_button "Allow"
  end
end

When /^I press "(.*?)" on the Trello popup$/ do |button|
  trello_popup = windows.last
  page.within_window trello_popup do
    click_button button
  end
end

def fake_chrome_drivers
  page.driver.header(
    "User-Agent",
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/34.0.1847.116 Chrome/34.0.1847.116 Safari/537.36"
    )
end