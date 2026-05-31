FactoryBot.define do
  factory :provide_ingredient do
    association :supplier
    association :ingredient_product
    reference_value { 9.99 }
    delivery_time { nil }
    delivery_time_type { nil }
    association :created_by, factory: :user

    trait :delivery do
      delivery_time { 5 }
      delivery_time_type { :hours }
    end
  end
end
