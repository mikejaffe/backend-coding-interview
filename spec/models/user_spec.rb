require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'requires uppercase in password' do
      user = build(:user, password: 'password123')
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include('must contain at least one uppercase letter')
    end

    it 'requires special character in password' do
      user = build(:user, password: 'Password123')
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include('must contain at least one special character')
    end

    it 'accepts valid password' do
      user = build(:user)
      expect(user).to be_valid
    end
  end

  describe '#api_token' do
    it 'generates token on creation' do
      user = create(:user)
      expect(user.api_token).to be_present
    end
  end
end
