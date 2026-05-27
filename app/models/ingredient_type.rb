class IngredientType < ApplicationRecord
  include UniqueStringNormalizer
  normalizer :name

  attr_readonly :created_by_id, :name, :ingredient_category_id, :base_measurement_unit_id

  validates :name, presence: true, uniqueness: true
  validates :ingredient_category, presence: true
  validates :base_measurement_unit, presence: true
  validates :min_stock, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :active, inclusion: { in: [ true, false ] }
  validates :created_by, presence: true

  belongs_to :ingredient_category
  belongs_to :base_measurement_unit, class_name: "MeasurementUnit"
  belongs_to :created_by, class_name: "User"
end
