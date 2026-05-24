FactoryBot.define do
  factory :permission do
    sequence(:resource) { |n| "stock #{n}" }
    sequence(:action) { |n| "read #{n}" }
    description { "Can read stock" }
  end
end
