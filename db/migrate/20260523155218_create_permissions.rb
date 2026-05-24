class CreatePermissions < ActiveRecord::Migration[8.1]
  def change
    create_table :permissions do |t|
      t.string :resource, null: false
      t.string :action, null: false
      t.string :description, null: true

      t.timestamps

      t.index [ :resource, :action ], unique: true
    end
  end
end
