require 'bcrypt'
require 'mongoid'

require_relative 'user'

class PasswordReset
  include Mongoid::Document

  embedded_in :user

  field :reset_hash, type: String
  field :expiration_date, type: DateTime

  def self.generate(email)
    PasswordReset.new reset_hash: Digest::MD5.hexdigest("#{Time.now.nsec}#{email}"),
                      expiration_date: DateTime.now + 1.days
  end

  def expired?
    expiration_date.nil? || DateTime.now > expiration_date
  end
end