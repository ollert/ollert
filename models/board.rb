require 'mongoid'

class Board
  include Mongoid::Document

  field :board_id, type: String
  field :starting_list, type: String
  field :ending_list, type: String

  embedded_in :user
end