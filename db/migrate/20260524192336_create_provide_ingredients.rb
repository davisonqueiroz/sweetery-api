class CreateProvideIngredients < ActiveRecord::Migration[8.1]
  def change
    create_table :provide_ingredients do |t|
      t.references :supplier, null: false, foreign_key: true, index: false
      t.references :ingredient_product, null: false, foreign_key: true, index: false
      t.decimal :reference_value, null: false, precision: 10, scale: 2
      t.float :delivery_time
      t.integer :delivery_time_type
      t.references :created_by, null: false, foreign_key: { to_table: :users }, index: false

      t.timestamps

      t.index [ :supplier_id, :ingredient_product_id ], unique: true

      t.check_constraint "delivery_time IS NULL OR delivery_time_type IS NOT NULL"
      t.check_constraint "delivery_time IS NULL OR delivery_time > 0"
      t.check_constraint "reference_value > 0"
    end
  end
end
