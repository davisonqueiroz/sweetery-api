class IngredientCategory < ApplicationRecord
  include UniqueStringNormalizer
  normalizer :name

  attr_readonly :created_by_id, :name

  validates :name, presence: true, uniqueness: true
  validates :active, inclusion: { in: [ true, false ] }
  validates :created_by, presence: true

  belongs_to :created_by, class_name: "User"
end
