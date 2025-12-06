require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }
  end

  describe 'associations' do
    it { should belong_to(:project) }
  end

  describe 'factory' do
    it 'creates a valid task' do
      task = build(:task)
      expect(task).to be_valid
    end
  end

  describe 'default values' do
    it 'defaults completed to false' do
      task = create(:task)
      expect(task.completed).to eq(false)
    end
  end
end
