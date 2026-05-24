class CreateRolePermissions < ActiveRecord::Migration[8.1]
  def change
    create_table :role_permissions do |t|
      t.references :role, null: false, foreign_key: true, index: false
      t.references :permission, null: false, foreign_key: true, index: false

      t.timestamps

      t.index [ :role_id, :permission_id ], unique: true
    end
  end
end
