class Environment
  class << self
    def test_display_name
      ENV['TRELLO_TEST_DISPLAY_NAME']
    end

    def test_username
      ENV['TRELLO_TEST_USERNAME']
    end

    def test_password
      ENV['TRELLO_TEST_PASSWORD']
    end

    def public_key
      ENV['PUBLIC_KEY']
    end
  end
end