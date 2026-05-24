class Permission < ApplicationRecord
  attr_readonly :resource, :action
  before_validation :string_normalizer, on: :create
  validates :resource, presence: true
  validates :action, presence: true
  validates :resource, uniqueness: { scope: :action }

  private

  def string_normalizer
    self.resource = resource.downcase if resource.present?
    self.action = action.downcase if action.present?
  end
end
