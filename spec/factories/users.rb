FactoryBot.define do
  factory :user do
    email { "teste@dev.dev" }
    password { "password" }
    password_confirmation { "password" }
  end
end
