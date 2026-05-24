FactoryBot.define do
  factory :user_role do
    association :user
    association :role
    association :created_by, factory: :user
  end
end
