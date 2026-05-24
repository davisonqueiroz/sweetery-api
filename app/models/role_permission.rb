class RolePermission < ApplicationRecord
  attr_readonly :role_id, :permission_id
  validates :role, :permission, presence: true
  validates :role, uniqueness: { scope: :permission }
  belongs_to :role
  belongs_to :permission
end
