FactoryBot.define do
  factory :role do
    sequence(:name) { |n| "inventory #{n}" }
    description { "Role responsable from control of inventory." }
    active { true }
    association :created_by, factory: :user
  end
end
