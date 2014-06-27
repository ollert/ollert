require 'bcrypt'
require 'mongoid'

class User
  include Mongoid::Document

  field :email, type: String
  field :password_hash, type: String
  field :member_token, type: String
  field :trello_name, type: String

  validates_uniqueness_of :email
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
      return "Current password entered incorrectly. Try again."
    end

    if proposed.nil_or_empty?
      return "Password must contain at least 1 character."
    end

    if proposed != confirmed
      return "New password fields do not match."
    end

    self.password = proposed
    if !save
      if user.errors.any?
        error_list = ""
        user.errors.full_messages.each { |x| error_list << "<li>#{x}</li>" }
        return "Could not update password: <ul>#{error_list}</ul>"
      else
        return "Password could not be updated."
      end
    end
  end
end
