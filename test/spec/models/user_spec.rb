require_relative '../../../models/user'

describe User do
  describe '#password=' do
    before :each do
      @password = 'valid password'
      @user = User.new
      @user.password = @password
    end

    it 'sets password_hash to nil for nil password' do
      expect(@user.password_hash).not_to be_nil
      @user.password = nil
      expect(@user.password_hash).to be_nil
    end

    it 'sets password_hash to nil for empty password' do
      expect(@user.password_hash).not_to be_nil
      @user.password = ''
      expect(@user.password_hash).to be_nil
    end

    it 'creates new hash for new different password' do
      pw_hash = @user.password_hash
      expect(pw_hash).not_to be_nil
      new_pw = 'new password'
      expect(new_pw).not_to eq @password
      @user.password = new_pw
      new_pw_hash = @user.password_hash
      expect(new_pw_hash).not_to be_nil
      expect(new_pw_hash).not_to eq pw_hash
    end

    it 'creates new hash for new password even if same' do
      pw_hash = @user.password_hash
      expect(pw_hash).not_to be_nil
      @user.password = @password
      new_pw_hash = @user.password_hash
      expect(new_pw_hash).not_to be_nil
      expect(new_pw_hash).not_to eq pw_hash
    end
  end

  describe '#authenticate?' do
    before :each do
      @password = "super-secret"
      @user = User.new
      @user.password = @password
    end

    it 'returns false for nil password' do
      expect(@user.authenticate?(nil)).to be false
    end

    it 'returns false for bad password' do
      badpw = "password"
      expect(badpw).not_to eq @password
      expect(@user.authenticate?(badpw)).to be false
    end

    it 'returns true for correct password' do
      expect(@user.authenticate?(@password)).to be true
    end
  end

  describe '#change_password' do
    it 'returns true on success' do
      user = User.new :email => "me@email.com"
      user.password = "current"
      old_hash = user.password_hash
      expect(old_hash).not_to be_nil

      expect(user.change_password("current", "new", "new")[:status]).to be true
      expect(user.password_hash).not_to be old_hash
    end

    it 'returns false on bad current password' do
      user = User.new :email => "me@email.com"
      user.password = "good"
      old_hash = user.password_hash
      expect(old_hash).not_to be_nil

      result = user.change_password("bad", "new", "new")
      expect(result[:status]).to be false
      expect(result[:message]).to eq "Current password entered incorrectly."
      expect(user.password_hash).to be old_hash
    end

    it 'returns false on bad new password' do
      user = User.new :email => "me@email.com"
      user.password = "current"
      old_hash = user.password_hash
      expect(old_hash).not_to be_nil

      result = user.change_password("current", "", "")
      expect(result[:status]).to be false
      expect(result[:message]).to eq "Password must contain at least 1 character."
      expect(user.password_hash).to be old_hash
    end

    it 'returns false on non-matching new password' do
      user = User.new :email => "me@email.com"
      user.password = "current"
      old_hash = user.password_hash
      expect(old_hash).not_to be_nil

      result = user.change_password("current", "good", "bad")
      expect(result[:status]).to be false
      expect(result[:message]).to eq "New password fields do not match."
      expect(user.password_hash).to be old_hash
    end
  end

  describe 'database' do
    before :all do
      Mongoid.load! "#{File.dirname(__FILE__)}/../../../mongoid.yml", :test
      Mongoid.purge!
      I18n.enforce_available_locales = true
    end

    after :each do
      Mongoid.purge!
    end

    describe '#email' do
      it 'must be unique' do
        user1 = User.new :email => "abc@def", :password_hash => "123"
        user2 = User.new :email => "abc@def", :password_hash => "456"
        expect(user1.save).to be true
        expect(user2.save).to be false
        expect(user2.errors.full_messages).to match_array(["Email is already taken"])
      end
    end
  end
end
