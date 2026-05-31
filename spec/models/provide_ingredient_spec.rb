require 'rails_helper'

RSpec.describe ProvideIngredient, type: :model do
  describe "create provide_ingredient" do
    let!(:provide_ingredient) { create(:provide_ingredient) }
    context "when creation is sucessfull" do
      it "create provide_ingredient" do
        expect(provide_ingredient).to be_valid
      end

      it "create with delivery_time" do
        provide_ingredient = create(:provide_ingredient, :delivery)

        expect(provide_ingredient).to be_valid
      end
      it "create without delivery_time and delivery_time_type" do
        provide_ingredient = create(:provide_ingredient, delivery_time: nil, delivery_time_type: nil)

        expect(provide_ingredient).to be_valid
      end
    end

    context "when creation is invalid" do
      it "delivery_time_type without delivery_time" do
        invalid_provide = build(:provide_ingredient, :delivery, delivery_time: nil)

        expect(invalid_provide).to be_invalid
        expect(invalid_provide.errors[:delivery_time]).to include("can't be blank")
      end

      it "delivery_time without delivery_time_type" do
        invalid_provide = build(:provide_ingredient, :delivery, delivery_time_type: nil)

        expect(invalid_provide).to be_invalid
        expect(invalid_provide.errors[:delivery_time_type]).to include("can't be blank")
      end

      it "delivery_time less than 0" do
        invalid_provide = build(:provide_ingredient, :delivery, delivery_time: -1)

        expect(invalid_provide).to be_invalid
        expect(invalid_provide.errors[:delivery_time]).to include("must be greater than 0")
      end

      it "delivery_time equal 0" do
        invalid_provide = build(:provide_ingredient, :delivery, delivery_time: 0)

        expect(invalid_provide).to be_invalid
        expect(invalid_provide.errors[:delivery_time]).to include("must be greater than 0")
      end

      it "delivery_time_type with invalid value" do
        expect { build(:provide_ingredient, delivery_time_type: :invalid) }.to raise_error(ArgumentError)
      end

      it "combination of supplier and ingredient_product already exists" do
        invalid_provide = build(:provide_ingredient,
        supplier: provide_ingredient.supplier,
        ingredient_product: provide_ingredient.ingredient_product
        )

        expect(invalid_provide).to be_invalid
        expect(invalid_provide.errors[:supplier]).to include("has already been taken")
      end

      it "reference_value less than 0" do
        invalid_provide = build(:provide_ingredient, reference_value: -1)

        expect(invalid_provide).to be_invalid
        expect(invalid_provide.errors[:reference_value]).to include("must be greater than 0")
      end

      it "reference_value equal 0" do
        invalid_provide = build(:provide_ingredient, reference_value: 0)

        expect(invalid_provide).to be_invalid
        expect(invalid_provide.errors[:reference_value]).to include("must be greater than 0")
      end
    end

    context "when have nil values in required attributes" do
      it "supplier is nil" do
        invalid_provide = build(:provide_ingredient, supplier: nil)

        expect(invalid_provide).to be_invalid
        expect(invalid_provide.errors[:supplier]).to include("can't be blank")
      end

      it "ingredient_product is nil" do
        invalid_provide = build(:provide_ingredient, ingredient_product: nil)

        expect(invalid_provide).to be_invalid
        expect(invalid_provide.errors[:ingredient_product]).to include("can't be blank")
      end

      it "reference_value is nil" do
        invalid_provide = build(:provide_ingredient, reference_value: nil)

        expect(invalid_provide).to be_invalid
        expect(invalid_provide.errors[:reference_value]).to include("can't be blank")
      end

      it "created_by is nil" do
        invalid_provide = build(:provide_ingredient, created_by: nil)

        expect(invalid_provide).to be_invalid
        expect(invalid_provide.errors[:created_by]).to include("can't be blank")
      end
    end
  end

  describe "update provide_ingredient" do
    let!(:provide_ingredient) { create(:provide_ingredient, :delivery) }
    context "when update is valid" do
      it "update delivery_time" do
        expect { provide_ingredient.update(delivery_time: 12) }.to change(provide_ingredient, :delivery_time).from(provide_ingredient.delivery_time).to(12)
      end

      it "update delivery_time_type" do
        expect { provide_ingredient.update(delivery_time_type: :days) }.to change(provide_ingredient, :delivery_time_type).from(provide_ingredient.delivery_time_type).to("days")
      end

      it "update reference_value" do
        expect { provide_ingredient.update(reference_value: 12.72) }.to change(provide_ingredient, :reference_value).from(provide_ingredient.reference_value).to(12.72)
      end
    end

    context "when try update attributes only read" do
      it "try update created_by" do
        other_user = create(:user)

        expect { provide_ingredient.update(created_by: other_user) }.to raise_error(ActiveRecord::ReadonlyAttributeError)
      end

      it "try update supplier" do
        other_supplier = create(:supplier)

        expect { provide_ingredient.update(supplier: other_supplier) }.to raise_error(ActiveRecord::ReadonlyAttributeError)
      end

      it "try update ingredient_product" do
        other_ingredient_product = create(:ingredient_product)

        expect { provide_ingredient.update(ingredient_product: other_ingredient_product) }.to raise_error(ActiveRecord::ReadonlyAttributeError)
      end
    end

    context "when update is invalid" do
      it "update delivery_time_type to invalid value" do
        expect { provide_ingredient.update(delivery_time_type: "to nil") }.to raise_error(ArgumentError)
      end

      it "update delivery_time to nil" do
        provide_ingredient.update(delivery_time: nil)

        expect(provide_ingredient).to be_invalid
        expect(provide_ingredient.errors[:delivery_time]).to include("can't be blank")
      end

      it "update reference_value to nil" do
        provide_ingredient.update(reference_value: nil)

        expect(provide_ingredient).to be_invalid
        expect(provide_ingredient.errors[:reference_value]).to include("can't be blank")
      end
    end
  end
end
