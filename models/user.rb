require 'sequel'
require 'bcrypt'

class User < Sequel::Model
  set_primary_key [:id]
  one_to_many :board

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
