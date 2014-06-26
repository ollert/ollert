require 'bcrypt'
require 'mongoid'

class User
  include Mongoid::Document

  field :email, type: String
  field :password_hash, type: String
  field :member_token, type: String
  field :trello_name, type: String

  def password=(new_password)
    if new_password.nil? || new_password.empty?
      self.password_hash = nil
    else
      self.password_hash = BCrypt::Password.create new_password
    end
  end

  def authenticate?(password)
    return !self.password_hash.nil? &&
            BCrypt::Password.new(self.password_hash) == password
  end
end
