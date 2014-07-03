require 'bcrypt'
require 'mongoid'

require_relative '../core_ext/string.rb'

class User
  include Mongoid::Document

  field :email, type: String
  field :password_hash, type: String
  field :member_token, type: String
  field :trello_name, type: String

  validates_uniqueness_of :email
  validates_length_of :email, minimum: 1
  validates_length_of :password_hash, minimum: 1

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

  def change_password(current, proposed, confirmed)
    if !authenticate? current
      return {status: false, message: "Current password entered incorrectly."}
    end

    if proposed.nil_or_empty?
      return {status: false, message: "Password must contain at least 1 character."}
    end

    if proposed != confirmed
      return {status: false, message: "New password fields do not match."}
    end

    self.password = proposed
    return {status: true}
  end
end
