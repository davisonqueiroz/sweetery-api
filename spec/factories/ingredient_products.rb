FactoryBot.define do
  factory :ingredient_product do
    association :ingredient_type
    sequence(:commercial_name) { |n| "granulated sugar_#{n}" }
    sequence(:brand) { |n| "cristal_#{n}" }
    package_quantity { 1.5 }
    association :package_measurement_unit, factory: :measurement_unit
    active { true }
    association :created_by, factory: :user
  end
end
