require 'page_navigation'

module OllertTest
  module Navigation
    include PageNavigation

    def on(cls, &block)
      screen = cls.new
      block.call screen if block
      screen
    end
  end
end