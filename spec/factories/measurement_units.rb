FactoryBot.define do
  factory :measurement_unit do
    sequence(:code) { |n| "kg_#{n}" }
    sequence (:name) { |n| "kilogram_#{n}" }
    dimension { 0 }
    is_base { false }
    conversion_factor { 1.00 }
    active { true }
    association :created_by, factory: :user
  end
end
