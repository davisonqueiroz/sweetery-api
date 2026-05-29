FactoryBot.define do
  factory :ingredient_category do
    sequence(:name) { |n|  "liquid_#{n}" }
    active { true }
    association :created_by, factory: :user
  end
end
