require 'sequel'

class Board < Sequel::Model
  many_to_one :user
end
