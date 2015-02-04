module SitePrism
  class Page
    def wait_until(&block)
      Waiter.wait_until_true &block
    end
  end
end