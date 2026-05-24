class Role < ApplicationRecord
  attr_readonly :created_by_id, :name

  before_validation :name_normalizer, on: :create

  validates :name, presence: true, uniqueness: true
  validates :active, inclusion: { in: [ true, false ] }

  belongs_to :created_by, class_name: "User", optional: true
  private

  def name_normalizer
    self.name = name.downcase if name.present?
  end
end
