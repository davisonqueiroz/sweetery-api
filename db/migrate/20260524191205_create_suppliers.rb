class CreateSuppliers < ActiveRecord::Migration[8.1]
  def change
    create_table :suppliers do |t|
      t.integer :type_supplier, null: false
      t.string :company_name
      t.string :fantasy_name
      t.string :document, null: false
      t.string :name
      t.boolean :active, null: false, default: true
      t.string :observation
      t.references :created_by, null: false, foreign_key: { to_table: :users }, index: false

      t.timestamps

      t.index :document, unique: true
      t.index :name, unique: true
      t.index :fantasy_name, unique: true
      t.index :company_name, unique: true

      t.check_constraint "type_supplier != 0 OR (name IS NOT NULL AND company_name IS NULL AND fantasy_name IS NULL)", name: "pf_name_required"
      t.check_constraint "type_supplier != 1 OR (company_name IS NOT NULL AND name IS NULL)", name: "pj_attributes_required"
    end
  end
end
