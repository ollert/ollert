class SettingsPage < SitePrism::Page
  set_url '/settings'
  element(:email_element, 'input#email')
  element(:update_email_element, 'input[value="Update Email"]')
  element(:email_status_element, '#email-status')

  def email
    email_element.value
  end

  def email=(value)
    email_element.set value
  end

  def update_email
    update_email_element.click
  end

  def email_status
    email_status_element.text
  end
end