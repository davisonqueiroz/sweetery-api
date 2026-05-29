require 'rails_helper'

RSpec.describe IngredientType, type: :model do
  describe "create ingredient_type" do
    let!(:ingredient_type) { create(:ingredient_type) }
    context "when creation is sucesfull" do
      it "create ingredient_type" do
        expect(ingredient_type).to be_valid
      end

      it "min_stock equal to 0" do
        ingredient_type = create(:ingredient_type, min_stock: 0)

        expect(ingredient_type).to be_valid
      end

      it "name in uppercase" do
        ingredient_type = create(:ingredient_type, name: "ChoColaTe")

        expect(ingredient_type).to be_valid
        expect(ingredient_type.name).to match("chocolate")
      end

      it "active is false" do
        ingredient_type = create(:ingredient_type, active: false)

        expect(ingredient_type).to be_valid
      end
    end

    context "when creation is invalid" do
      it "name already exists in downcase" do
        invalid_ingredient = build(:ingredient_type, name: ingredient_type.name.upcase)

        expect(invalid_ingredient).to be_invalid
        expect(invalid_ingredient.errors[:name]).to include("has already been taken")
      end

      it "min_stock less than 0" do
        invalid_ingredient = build(:ingredient_type, min_stock: -1)

        expect(invalid_ingredient).to be_invalid
        expect(invalid_ingredient.errors[:min_stock]).to include("must be greater than or equal to 0")
      end

      it "min_stock to non number value" do
        invalid_ingredient = build(:ingredient_type, min_stock: "non number")

        expect(invalid_ingredient).to be_invalid
        expect(invalid_ingredient.errors[:min_stock]).to include("is not a number")
      end

      it "active is not valid" do
        invalid_ingredient = build(:ingredient_type, active: nil)

        expect(invalid_ingredient).to be_invalid
        expect(invalid_ingredient.errors[:active]).to include("is not included in the list")
      end
    end

    context "when have nil value in required attributes" do
      it "name is nil" do
        invalid_ingredient = build(:ingredient_type, name: nil)

        expect(invalid_ingredient).to be_invalid
        expect(invalid_ingredient.errors[:name]).to include("can't be blank")
      end

      it "ingredient_category is nil" do
        invalid_ingredient = build(:ingredient_type, ingredient_category: nil)

        expect(invalid_ingredient).to be_invalid
        expect(invalid_ingredient.errors[:ingredient_category]).to include("can't be blank")
      end

      it "base_measurement_unit is nil" do
        invalid_ingredient = build(:ingredient_type, base_measurement_unit: nil)

        expect(invalid_ingredient).to be_invalid
        expect(invalid_ingredient.errors[:base_measurement_unit]).to include("can't be blank")
      end

      it "min_stock is nil" do
        invalid_ingredient = build(:ingredient_type, min_stock: nil)

        expect(invalid_ingredient).to be_invalid
        expect(invalid_ingredient.errors[:min_stock]).to include("can't be blank")
      end

      it "created_by is nil" do
        invalid_ingredient = build(:ingredient_type, created_by: nil)

        expect(invalid_ingredient).to be_invalid
        expect(invalid_ingredient.errors[:created_by]).to include("can't be blank")
      end
    end
  end

  describe "update ingredient_type" do
    let!(:ingredient_type) { create(:ingredient_type) }
    context "when update is valid" do
      it "update min_stock to equal 0" do
        expect { ingredient_type.update(min_stock: 0) }.to change(ingredient_type, :min_stock).from(1.5).to(0)
      end

      it "update min_stock to greater 0" do
        expect { ingredient_type.update(min_stock: 5) }.to change(ingredient_type, :min_stock).from(1.5).to(5)
      end
      it "update active" do
        expect { ingredient_type.update(active: false) }.to change(ingredient_type, :active).from(true).to(false)
      end

      it "update min_stock to less than 0" do
        ingredient_type.min_stock = -1

        expect(ingredient_type).to be_invalid
        expect(ingredient_type.errors[:min_stock]).to include("must be greater than or equal to 0")
      end

      it "update min_stock to non number value" do
        ingredient_type.min_stock = "other value"

        expect(ingredient_type).to be_invalid
        expect(ingredient_type.errors[:min_stock]).to include("is not a number")
      end

      it "update active to invalid value" do
        ingredient_type.active = nil

        expect(ingredient_type).to be_invalid
        expect(ingredient_type.errors[:active]).to include("is not included in the list")
      end
    end

    context "update required values to nil" do
      it "update min_stock" do
        ingredient_type.min_stock = nil

        expect(ingredient_type).to be_invalid
        expect(ingredient_type.errors[:min_stock]).to include("can't be blank")
      end
    end

    context "attempt to update readable attributes" do
      it "update name" do
        expect { ingredient_type.update(name: "other_value") }.to raise_error(ActiveRecord::ReadonlyAttributeError)
      end
      it "update created_by" do
        other_user = create(:user)
        expect { ingredient_type.update(created_by: other_user) }.to raise_error(ActiveRecord::ReadonlyAttributeError)
      end
      it "update base_measurement" do
        other_measurement = create(:measurement_unit)
        expect { ingredient_type.update(base_measurement_unit: other_measurement) }.to raise_error(ActiveRecord::ReadonlyAttributeError)
      end
      it "update ingredient_category" do
        other_ingredient_category = create(:ingredient_category)
        expect { ingredient_type.update(ingredient_category: other_ingredient_category) }.to raise_error(ActiveRecord::ReadonlyAttributeError)
      end
    end
  end
end
