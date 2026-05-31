FactoryBot.define do
  require "cpf_cnpj"
  factory :supplier do
    type_supplier { :pf }
    company_name { nil }
    fantasy_name { nil }
    document { CPF.generate }
    sequence(:name)  { |n| "supplier_#{n}" }
    active { true }
    observation { "this text is one example of observation to supplier" }
    association :created_by, factory: :user

    trait :pj do
      type_supplier { :pj }
      sequence(:company_name)  { |n| "company_#{n}" }
      sequence(:fantasy_name) { |n| "fantasy_#{n}" }
      document { CNPJ.generate }
      name { nil }
    end
  end
end
