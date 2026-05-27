class CreateIngredientCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :ingredient_categories do |t|
      t.string :name, null: false
      t.boolean :active, null: false, default: true
      t.references :created_by, null: false, foreign_key: { to_table: :users }, index: false

      t.timestamps

      t.index :name, unique: true
    end
  end
end
