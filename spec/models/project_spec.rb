require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'associations' do
    it { should have_many(:tasks).dependent(:destroy) }
  end

  describe 'factory' do
    it 'creates a valid project' do
      project = build(:project)
      expect(project).to be_valid
    end
  end

  describe 'dependent destroy' do
    it 'destroys associated tasks when project is destroyed' do
      project = create(:project)
      task = create(:task, project: project)

      expect { project.destroy }.to change(Task, :count).by(-1)
    end
  end
end
