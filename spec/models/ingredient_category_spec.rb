require 'rails_helper'

RSpec.describe IngredientCategory, type: :model do
  describe "create ingredient category" do
    let!(:ingredient_category) { create(:ingredient_category) }
    context "when creation is sucesfull" do
      it "creates a ingredient category" do
        expect(ingredient_category).to be_valid
      end

      it "name in uppercase" do
        new_category = build(:ingredient_category, name: "Fruits")

        expect(new_category).to be_valid
        expect(new_category.name).to match("fruits")
      end

      it "active is false" do
        new_category = build(:ingredient_category, active: false)

        expect(new_category).to be_valid
        expect(new_category.active).to match(false)
      end
    end

    context "when creation is invalid" do
      it "name already exists" do
        invalid_category = build(:ingredient_category, name: ingredient_category.name)

        expect(invalid_category).to be_invalid
        expect(invalid_category.errors[:name]).to include("has already been taken")
      end

      it "name is nil" do
        invalid_category = build(:ingredient_category, name: nil)

        expect(invalid_category).to be_invalid
        expect(invalid_category.errors[:name]).to include("can't be blank")
      end

      it "created_by is nil" do
        invalid_category = build(:ingredient_category, created_by: nil)

        expect(invalid_category).to be_invalid
        expect(invalid_category.errors[:created_by]).to include("can't be blank")
      end

      it "active is nil" do
        invalid_category = build(:ingredient_category, active: nil)

        expect(invalid_category).to be_invalid
        expect(invalid_category.errors[:active]).to include("is not included in the list")
      end
    end
  end

  describe "update ingredient category" do
    let!(:ingredient_category) { create(:ingredient_category) }
    context "when update is valid" do
      it "update active attribute" do
        expect { ingredient_category.update(active: false) }.to change(ingredient_category, :active).from(true).to(false)
      end
    end

    context "when update is invalid" do
      it "update name" do
        expect { ingredient_category.update(name: "other value") }.to raise_error(ActiveRecord::ReadonlyAttributeError)
      end
      it "update created_by" do
        other_user = create(:user)

        expect { ingredient_category.update(created_by: other_user) }.to raise_error(ActiveRecord::ReadonlyAttributeError)
      end

      it "update active to nil" do
        ingredient_category.active = nil

        expect(ingredient_category).to be_invalid
        expect(ingredient_category.errors[:active]).to include("is not included in the list")
      end
    end
  end
end
