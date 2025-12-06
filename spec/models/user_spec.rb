require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build(:user) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should allow_value('user@example.com').for(:email) }
    it { should_not allow_value('invalid').for(:email) }
  end

  describe 'associations' do
    it { should have_many(:projects).dependent(:destroy) }
  end

  describe 'password' do
    it 'requires minimum length' do
      user = build(:user, password: 'short', password_confirmation: 'short')
      expect(user).not_to be_valid
    end
  end
end
