require_relative '../../../models/password_reset'

describe PasswordReset do
  describe '#generate' do
    it 'creates a hash and expiration date one day in the future' do
      now = DateTime.now
      expect(DateTime).to receive(:now).and_return(now)

      pw = PasswordReset.generate "ollerttest@gmail.com"
      expect(pw.reset_hash).to_not be_nil
      expect(pw.expiration_date).to eq (now + 1.days)
    end
  end

  describe '#expired' do
    it 'returns true for nil expiration date' do
      pw = PasswordReset.new
      expect(pw.expired?).to be true
    end

    it 'returns true for expired reset' do
      now = DateTime.now
      expect(DateTime).to receive(:now).and_return(now)

      pw = PasswordReset.new expiration_date: (now - 1.days - 1.minutes)
      expect(pw.expired?).to be true
    end

    it 'returns false for non-expired reset' do
      now = DateTime.now
      expect(DateTime).to receive(:now).and_return(now)

      pw = PasswordReset.new expiration_date: (now + 1.minutes)
      expect(pw.expired?).to be false
    end
  end
end
