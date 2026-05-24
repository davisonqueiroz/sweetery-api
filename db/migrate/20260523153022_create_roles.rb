class CreateRoles < ActiveRecord::Migration[8.1]
  def change
    create_table :roles do |t|
      t.string :name, null: false
      t.string :description
      t.boolean :active, null: false, default: true
      t.references :created_by, null: true, foreign_key: { to_table: :users }, index: false

      t.timestamps

      t.index :name, unique: true
    end
  end
end
