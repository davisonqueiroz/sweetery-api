class IngredientCategory < ApplicationRecord
  include UniqueStringNormalizer
  normalizer :name

  attr_readonly :created_by_id, :name

  validates :name, presence: true, uniqueness: true
  validates :active, inclusion: { in: [ true, false ] }

  belongs_to :created_by, class_name: "User"
end
