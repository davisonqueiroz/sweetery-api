class ProvideIngredient < ApplicationRecord
  attr_readonly :created_by_id, :supplier_id, :ingredient_product_id

  validates :supplier, presence: true, uniqueness: { scope: :ingredient_product }
  validates :ingredient_product, presence: true
  validates :reference_value, presence: true, numericality: { greater_than: 0 }
  validates :created_by, presence: true
  validates :delivery_time_type, presence: true, if: -> { delivery_time? }
  validates :delivery_time, presence: true, if: -> { delivery_time_type? }
  validates :delivery_time, numericality: { greater_than: 0 }, allow_nil: true

  enum :delivery_time_type, { hours: 0, days: 1, weeks: 2, months: 3 }

  belongs_to :supplier
  belongs_to :ingredient_product
  belongs_to :created_by, class_name: "User"
end
