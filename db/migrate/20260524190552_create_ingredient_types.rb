class CreateIngredientTypes < ActiveRecord::Migration[8.1]
  def change
    create_table :ingredient_types do |t|
      t.string :name, null: false
      t.references :ingredient_category, null: false, foreign_key: true, index: false
      t.references :base_measurement_unit, null: false, foreign_key: { to_table: :measurement_units }, index: false
      t.decimal :min_stock, null: false, default: 0, precision: 10, scale: 3
      t.boolean :active, null: false, default: true
      t.references :created_by, null: false, foreign_key: { to_table: :users }, index: false

      t.timestamps

      t.index :name, unique: true
    end
  end
end
