class IngredientProduct < ApplicationRecord
  include UniqueStringNormalizer
  normalizer :commercial_name, :brand

  attr_readonly :ingredient_type_id, :commercial_name, :brand,
                :package_measurement_unit_id, :created_by_id

  validates :ingredient_type, presence: true
  validates :commercial_name, presence: true
  validates :brand, presence: true
  validates :package_quantity, presence: true, numericality: { greater_than: 0 }
  validates :package_measurement_unit, presence: true
  validates :active, inclusion: { in: [ true, false ] }
  validates :created_by, presence: true
  validates :commercial_name, uniqueness: { scope: [ :brand, :package_quantity, :package_measurement_unit_id ] }

  belongs_to :ingredient_type
  belongs_to :package_measurement_unit, class_name: "MeasurementUnit"
  belongs_to :created_by, class_name: "User"
end
