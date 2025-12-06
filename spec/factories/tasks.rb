FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "Task #{n}" }
    completed { false }
    association :project
  end
end
