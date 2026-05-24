class UserRole < ApplicationRecord
  attr_readonly :user_id, :role_id, :created_by_id

  validates :user, :role, presence: true
  validates :user, uniqueness: { scope: :role_id }

  belongs_to :user
  belongs_to :role
  belongs_to :created_by, class_name: "User", optional: true
end
