require 'mongoid'

class Board
  include Mongoid::Document

  field :board_id, type: String
  field :starting_list, type: String
  field :ending_list, type: String
  field :show_archived, type: Boolean

  embedded_in :user
end
