class CreateMeasurementUnits < ActiveRecord::Migration[8.1]
  def change
    create_table :measurement_units do |t|
      t.string :code, null: false
      t.string :name, null: false
      t.integer :dimension, null: false
      t.boolean :is_base, default: false
      t.decimal :conversion_factor, null: false,  precision: 10, scale: 2
      t.boolean :active, null: false, default: true
      t.references :created_by, null: false, foreign_key: { to_table: :users }, index: false

      t.timestamps

      t.index :code, unique: true
      t.index :dimension, unique: true, where: "is_base = true AND active = true"
      t.check_constraint "conversion_factor > 0", name: "conversion_check"
    end
  end
end
