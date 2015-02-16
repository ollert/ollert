class TrelloIntegrationHelper

  def self.client
    @client ||= Trello::Client.new developer_public_key: Trello.configuration.developer_public_key, member_token: Trello.configuration.member_token
  end

  def self.board_id
    board.id
  end

  def self.add_card
    Trello::Card.create list_id: first_list.id, name: "Card ##{next_card}"
  end

  def self.first_list
    @first_list ||= Trello::List.create(board_id: board.id, name: 'Integration Test List #1')
  end

  def self.second_list
    @second_list ||= Trello::List.create(board_id: board.id, name: 'Integration Test List #2')
  end

  def self.cleanup
    [@first_list, @second_list].compact.each do |list|
      list.close!
    end
  end

  class << self
    def board
      @board ||= Trello::Board.all.find {|b| b.name == 'Test Board #1'}
    end

    def next_card
      @next_card ||= 0
      @next_card += 1
    end
  end

  private_class_method :board, :next_card
end

