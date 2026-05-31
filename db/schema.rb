# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_05_24_191205) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "ingredient_categories", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.bigint "created_by_id", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_ingredient_categories_on_name", unique: true
  end

  create_table "ingredient_products", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.string "brand", default: "no brand", null: false
    t.string "commercial_name", null: false
    t.datetime "created_at", null: false
    t.bigint "created_by_id", null: false
    t.bigint "ingredient_type_id", null: false
    t.bigint "package_measurement_unit_id", null: false
    t.decimal "package_quantity", precision: 10, scale: 3, null: false
    t.datetime "updated_at", null: false
    t.index ["commercial_name", "brand", "package_quantity", "package_measurement_unit_id"], name: "idx_on_commercial_name_brand_package_quantity_packa_ae53049e72", unique: true
  end

  create_table "ingredient_types", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.bigint "base_measurement_unit_id", null: false
    t.datetime "created_at", null: false
    t.bigint "created_by_id", null: false
    t.bigint "ingredient_category_id", null: false
    t.decimal "min_stock", precision: 10, scale: 3, default: "0.0", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_ingredient_types_on_name", unique: true
  end

  create_table "measurement_units", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.string "code", null: false
    t.decimal "conversion_factor", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.bigint "created_by_id", null: false
    t.integer "dimension", null: false
    t.boolean "is_base", default: false, null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_measurement_units_on_code"
    t.index ["dimension"], name: "index_measurement_units_on_dimension", unique: true, where: "((is_base = true) AND (active = true))"
    t.index ["name"], name: "index_measurement_units_on_name"
    t.check_constraint "conversion_factor > 0::numeric", name: "conversion_check"
  end

  create_table "permissions", force: :cascade do |t|
    t.string "action", null: false
    t.datetime "created_at", null: false
    t.string "description"
    t.string "resource", null: false
    t.datetime "updated_at", null: false
    t.index ["resource", "action"], name: "index_permissions_on_resource_and_action", unique: true
  end

  create_table "role_permissions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "permission_id", null: false
    t.bigint "role_id", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id", "permission_id"], name: "index_role_permissions_on_role_id_and_permission_id", unique: true
  end

  create_table "roles", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.bigint "created_by_id"
    t.string "description"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_roles_on_name", unique: true
  end

  create_table "suppliers", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.string "company_name"
    t.datetime "created_at", null: false
    t.bigint "created_by_id", null: false
    t.string "document", null: false
    t.string "fantasy_name"
    t.string "name"
    t.string "observation"
    t.integer "type_supplier", null: false
    t.datetime "updated_at", null: false
    t.index ["company_name"], name: "index_suppliers_on_company_name", unique: true
    t.index ["document"], name: "index_suppliers_on_document", unique: true
    t.index ["fantasy_name"], name: "index_suppliers_on_fantasy_name", unique: true
    t.index ["name"], name: "index_suppliers_on_name", unique: true
    t.check_constraint "type_supplier <> 0 OR name IS NOT NULL AND company_name IS NULL AND fantasy_name IS NULL", name: "pf_name_required"
    t.check_constraint "type_supplier <> 1 OR company_name IS NOT NULL AND name IS NULL", name: "pj_attributes_required"
  end

  create_table "user_roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "created_by_id"
    t.bigint "role_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id", "role_id"], name: "index_user_roles_on_user_id_and_role_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "jti", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "ingredient_categories", "users", column: "created_by_id"
  add_foreign_key "ingredient_products", "ingredient_types"
  add_foreign_key "ingredient_products", "measurement_units", column: "package_measurement_unit_id"
  add_foreign_key "ingredient_products", "users", column: "created_by_id"
  add_foreign_key "ingredient_types", "ingredient_categories"
  add_foreign_key "ingredient_types", "measurement_units", column: "base_measurement_unit_id"
  add_foreign_key "ingredient_types", "users", column: "created_by_id"
  add_foreign_key "measurement_units", "users", column: "created_by_id"
  add_foreign_key "role_permissions", "permissions"
  add_foreign_key "role_permissions", "roles"
  add_foreign_key "roles", "users", column: "created_by_id"
  add_foreign_key "suppliers", "users", column: "created_by_id"
  add_foreign_key "user_roles", "roles"
  add_foreign_key "user_roles", "users"
  add_foreign_key "user_roles", "users", column: "created_by_id"
end
