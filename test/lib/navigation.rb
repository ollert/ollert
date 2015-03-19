require 'page_navigation'

module OllertTest
  module Navigation
    include PageNavigation

    def on(cls)
      screen = cls.new
      yield screen if block_given?
      screen
    end

    def go_to(cls, &block)
      cls.new.load
      on(cls, &block)
    end
  end
end