class MeasurementUnit < ApplicationRecord
  include UniqueStringNormalizer
  normalizer :code, :name

  attr_readonly :created_by_id, :code, :name, :dimension

  before_validation :check_base_exists, on: [ :create, :update ]

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
  validates :dimension, presence: true
  validates :active, inclusion: { in: [ true, false ] }
  validates :created_by, presence: true
  validates :conversion_factor, presence: true, numericality: { greater_than: 0 }

  enum dimension: { mass: 0, volume: 1, unit: 2 }

  belongs_to :created_by, class_name: "User"

  private

  def check_base_exists
    return unless is_base?

    has_base = MeasurementUnit.where(dimension: dimension, is_base: true, active: true)
      .where.not(id: id)
      .exists?

    if has_base
      errors.add(:dimension, "already exists base from this dimension.")
    end
  end
end
