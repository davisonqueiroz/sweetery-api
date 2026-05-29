FactoryBot.define do
  factory :ingredient_type do
    sequence (:name) { |n| "flour_#{n}" }
    association :ingredient_category
    association :base_measurement_unit, factory: :measurement_unit
    min_stock { 1.5 }
    active { true }
    association :created_by, factory: :user
  end
end
