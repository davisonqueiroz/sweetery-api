class Permission < ApplicationRecord
  include UniqueStringNormalizer
  normalizer :resource, :action

  attr_readonly :resource, :action

  validates :resource, presence: true
  validates :action, presence: true
  validates :resource, uniqueness: { scope: :action }
end
