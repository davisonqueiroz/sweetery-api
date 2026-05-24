class CreateUserRoles < ActiveRecord::Migration[8.1]
  def change
    create_table :user_roles do |t|
      t.references :user, null: false, foreign_key: true, index: false
      t.references :role, null: false, foreign_key: true, index: false
      t.references :created_by, null: true, foreign_key: { to_table: :users }, index: false

      t.timestamps

      t.index [ :user_id, :role_id ], unique: true
    end
  end
end
