require 'mongoid'

class User
  include Mongoid::Document

  field :email, type: String
  field :trello_id, type: String
  field :trello_name, type: String
  field :member_token, type: String
  field :gravatar_hash, type: String

  validates_uniqueness_of :trello_id
end