require_rel 'accessors'

module SitePrism
  class Page
    extend Accessors

    def wait_until(&block)
      Waiter.wait_until_true &block
    end

    def the_current_page?
      self.class.the_current_page?
    end

    def self.the_current_page?
      page = self.new

      begin
        page.wait_until { page.current_url =~ /#{self.url}$/ }
      rescue TimeoutException
        raise "Expected the url to be #{self.url} but it was #{page.current_url}"
      end
      true
    end
  end
end