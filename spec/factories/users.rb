FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "teste#{n}@dev.dev" }
    password { "password" }
    password_confirmation { "password" }
  end
end
