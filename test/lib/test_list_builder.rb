require_rel '../spec/trello_integration_helper'
require 'pp'

class TestListBuilder
  def initialize(list_name)
    @helper = TrelloIntegrationHelper
    @list = @helper.add_list list_name
  end

  def with_cards(*names)
    names.each {|name| @helper.add_card @list.id }
  end

  def self.setup_list(list_name)
    TestListBuilder.new list_name
  end
end

