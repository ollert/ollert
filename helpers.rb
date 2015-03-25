module OllertApp
  module Helpers
    def title_for(what=nil)
      "- #{what}" if what
    end
  end
end