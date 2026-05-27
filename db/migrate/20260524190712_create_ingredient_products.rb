class CreateIngredientProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :ingredient_products do |t|
      t.references :ingredient_type, null: false, foreign_key: true, index: false
      t.string :commercial_name, null: false
      t.string :brand, null: false, default: "no brand"
      t.decimal :package_quantity, null: false, precision: 10, scale: 3
      t.references :package_measurement_unit, null: false, foreign_key: { to_table: :measurement_units }, index: false
      t.boolean :active, null: false, default: true
      t.references :created_by, null: false, foreign_key: { to_table: :users }, index: false

      t.timestamps

      t.index [ :commercial_name, :brand, :package_quantity, :package_measurement_unit_id ], unique: true
    end
  end
end
