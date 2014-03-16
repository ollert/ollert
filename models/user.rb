require 'sequel'

class User < Sequel::Model
  one_to_many :board
end
