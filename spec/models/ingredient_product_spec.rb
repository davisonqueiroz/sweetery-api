require 'rails_helper'

RSpec.describe IngredientProduct, type: :model do
   describe "create measurement unit" do
    let!(:ingredient_product) { create(:ingredient_product) }
    context "when creation is sucessfull" do
      it "creates a ingredient_product" do
        expect(ingredient_product).to be_valid
      end

      it "create ingredient_product with uppercase in commercial_name" do
        ingredient_product = create(:ingredient_product, commercial_name: "fLouR")

        expect(ingredient_product).to be_valid
        expect(ingredient_product.commercial_name).to match("flour")
      end

      it "create ingredient_product with uppercase in brand" do
        ingredient_product = create(:ingredient_product, brand: "LacTA")

        expect(ingredient_product).to be_valid
        expect(ingredient_product.brand).to match("lacta")
      end

      it "create ingredient_product with the same attributes and other commercial_name" do
        other_ingredient_product = create(:ingredient_product,
                                      brand: ingredient_product.brand,
                                      package_quantity: ingredient_product.package_quantity,
                                      package_measurement_unit: ingredient_product.package_measurement_unit,
                                      commercial_name: "other_name"
                                    )

        expect(other_ingredient_product).to be_valid
      end

      it "create ingredient_product with the same attributes and other brand" do
        other_ingredient_product = create(:ingredient_product,
                                      brand: "other_brand",
                                      package_quantity: ingredient_product.package_quantity,
                                      package_measurement_unit: ingredient_product.package_measurement_unit,
                                      commercial_name: ingredient_product.commercial_name
                                    )

        expect(other_ingredient_product).to be_valid
      end

      it "create ingredient_product with the same attributes and other package_quantity" do
        other_ingredient_product = create(:ingredient_product,
                                      brand: ingredient_product.brand,
                                      package_quantity: 3.5,
                                      package_measurement_unit: ingredient_product.package_measurement_unit,
                                      commercial_name: ingredient_product.commercial_name
                                    )

        expect(other_ingredient_product).to be_valid
      end

      it "create ingredient_product with the same attributes and other package_measurement_unit" do
        other_measurement = create(:measurement_unit)
        other_ingredient_product = create(:ingredient_product,
                                      brand: ingredient_product.brand,
                                      package_quantity: ingredient_product.package_quantity,
                                      package_measurement_unit_id: other_measurement.id,
                                      commercial_name: ingredient_product.commercial_name
                                    )

        expect(other_ingredient_product).to be_valid
      end
    end

    context "when create is invalid" do
      it "index attribute combination already exists" do
        invalid_ingredient_product = build(:ingredient_product,
                                      brand: ingredient_product.brand,
                                      package_quantity: ingredient_product.package_quantity,
                                      package_measurement_unit_id: ingredient_product.package_measurement_unit_id,
                                      commercial_name: ingredient_product.commercial_name
                                    )

        expect(invalid_ingredient_product).to be_invalid
        expect(invalid_ingredient_product.errors[:commercial_name]).to include("has already been taken")
      end

      it "package_quantity is less than to 0" do
        invalid_ingredient_product = build(:ingredient_product, package_quantity: -1)

        expect(invalid_ingredient_product).to be_invalid
        expect(invalid_ingredient_product.errors[:package_quantity]).to include("must be greater than 0")
      end

      it "package_quantity is equal to 0" do
        invalid_ingredient_product = build(:ingredient_product, package_quantity: 0)

        expect(invalid_ingredient_product).to be_invalid
        expect(invalid_ingredient_product.errors[:package_quantity]).to include("must be greater than 0")
      end

      it "package_quantity is not number" do
        invalid_ingredient_product = build(:ingredient_product, package_quantity: "test")

        expect(invalid_ingredient_product).to be_invalid
        expect(invalid_ingredient_product.errors[:package_quantity]).to include("is not a number")
      end
    end

    context "create is invalid because nil values" do
      it "ingredient_type is nil" do
        invalid_ingredient_product = build(:ingredient_product, ingredient_type: nil)

        expect(invalid_ingredient_product).to be_invalid
        expect(invalid_ingredient_product.errors[:ingredient_type]).to include("can't be blank")
      end

      it "commercial_name is nil" do
        invalid_ingredient_product = build(:ingredient_product, commercial_name: nil)

        expect(invalid_ingredient_product).to be_invalid
        expect(invalid_ingredient_product.errors[:commercial_name]).to include("can't be blank")
      end

      it "brand is nil" do
        invalid_ingredient_product = build(:ingredient_product, brand: nil)

        expect(invalid_ingredient_product).to be_invalid
        expect(invalid_ingredient_product.errors[:brand]).to include("can't be blank")
      end

      it "package_quantity is nil" do
        invalid_ingredient_product = build(:ingredient_product, package_quantity: nil)

        expect(invalid_ingredient_product).to be_invalid
        expect(invalid_ingredient_product.errors[:package_quantity]).to include("can't be blank")
      end

      it "package_measurement_unit is nil" do
        invalid_ingredient_product = build(:ingredient_product, package_measurement_unit: nil)

        expect(invalid_ingredient_product).to be_invalid
        expect(invalid_ingredient_product.errors[:package_measurement_unit]).to include("can't be blank")
      end

      it "created_by is nil" do
        invalid_ingredient_product = build(:ingredient_product, created_by: nil)

        expect(invalid_ingredient_product).to be_invalid
        expect(invalid_ingredient_product.errors[:created_by]).to include("can't be blank")
      end
    end
   end

   describe "update measurement unit" do
    let!(:ingredient_product) { create(:ingredient_product) }
    context "when update is valid" do
      it "update active" do
        expect { ingredient_product.update(active: false) }.to change(ingredient_product, :active).from(true).to(false)
      end

      it "update package_quantity" do
        expect { ingredient_product.update(package_quantity: 3.0) }.to change(ingredient_product, :package_quantity).from(1.5).to(3.0)
      end
    end

    context "update is invalid" do
      it "update package_quantity to less than or equal 0" do
        ingredient_product.package_quantity = -4

        expect(ingredient_product).to be_invalid
        expect(ingredient_product.errors[:package_quantity]).to include("must be greater than 0")
      end

      it "update package_quantity to nil" do
        ingredient_product.package_quantity = nil

        expect(ingredient_product).to be_invalid
        expect(ingredient_product.errors[:package_quantity]).to include("is not a number")
      end

      it "update active to invalid value" do
        ingredient_product.active = nil

        expect(ingredient_product).to be_invalid
        expect(ingredient_product.errors[:active]).to include("is not included in the list")
      end
    end

    context "attempt to update readable attributes" do
      it "update ingredient_type" do
        other_ingredient_type = create(:ingredient_type)
        expect { ingredient_product.update(ingredient_type: other_ingredient_type) }.to raise_error(ActiveRecord::ReadonlyAttributeError)
      end

      it "update commercial_name" do
        expect { ingredient_product.update(commercial_name: "other name") }.to raise_error(ActiveRecord::ReadonlyAttributeError)
      end

      it "update brand" do
        expect { ingredient_product.update(brand: "other brand") }.to raise_error(ActiveRecord::ReadonlyAttributeError)
      end

      it "update package_measurement_unit" do
        other_measurement_unit = create(:measurement_unit)
        expect { ingredient_product.update(package_measurement_unit: other_measurement_unit) }.to raise_error(ActiveRecord::ReadonlyAttributeError)
      end

      it "update created_by" do
        other_user = create(:user)
        expect { ingredient_product.update(created_by: other_user) }.to raise_error(ActiveRecord::ReadonlyAttributeError)
      end
    end
   end
end
