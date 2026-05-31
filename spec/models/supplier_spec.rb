require 'rails_helper'

RSpec.describe Supplier, type: :model do
  describe "create supplier" do
    let!(:supplier) { create(:supplier) }
    context "when creation is sucessfull" do
      it "create supplier of pf type" do
        expect(supplier).to be_valid
      end

      it "create supplier of pj type" do
        create(:supplier, :pj)
        expect(supplier).to be_valid
      end

      it "create supplier of pj type" do
        create(:supplier, :pj)
        expect(supplier).to be_valid
      end

      it "create supplier pj without fantasy_name" do
        create(:supplier, :pj, fantasy_name: nil)
        expect(supplier).to be_valid
      end

      it "create supplier with name in uppercase" do
        new_supplier = create(:supplier, name: "NameTEst")

        expect(new_supplier).to be_valid
        expect(new_supplier.name).to match("nametest")
      end

      it "create supplier pj with uppercase" do
        new_supplier = create(:supplier, :pj, fantasy_name: "FantASy")
        expect(new_supplier).to be_valid
        expect(new_supplier.fantasy_name).to match("fantasy")
      end
    end

    context "when creation is invalid" do
      it "document already in use to pf" do
        invalid_supplier = build(:supplier, document: supplier.document)

        expect(invalid_supplier).not_to be_valid
        expect(invalid_supplier.errors[:document]).to include("has already been taken")
      end

      it "document already in use to pj" do
        supplier = create(:supplier, :pj)
        invalid_supplier = build(:supplier, :pj, document: supplier.document)

        expect(invalid_supplier).not_to be_valid
        expect(invalid_supplier.errors[:document]).to include("has already been taken")
      end

      it "name already in use" do
        invalid_supplier = build(:supplier, name: supplier.name)

        expect(invalid_supplier).not_to be_valid
        expect(invalid_supplier.errors[:name]).to include("has already been taken")
      end

      it "company_name already in use" do
        supplier = create(:supplier, :pj)
        invalid_supplier = build(:supplier, :pj, company_name: supplier.company_name)

        expect(invalid_supplier).not_to be_valid
        expect(invalid_supplier.errors[:company_name]).to include("has already been taken")
      end

      it "fantasy_name already in use" do
        supplier = create(:supplier, :pj)
        invalid_supplier = build(:supplier, :pj, fantasy_name: supplier.fantasy_name)

        expect(invalid_supplier).not_to be_valid
        expect(invalid_supplier.errors[:fantasy_name]).to include("has already been taken")
      end

      it "type_supplier is pf but name is blank" do
        invalid_supplier = build(:supplier, name: nil)

        expect(invalid_supplier).not_to be_valid
        expect(invalid_supplier.errors[:type_supplier]).to include("from pf supplier, only name is required")
      end

      it "type_supplier is pj but company_name is blank" do
        invalid_supplier = build(:supplier, :pj, company_name: nil)

        expect(invalid_supplier).not_to be_valid
        expect(invalid_supplier.errors[:type_supplier]).to include("to supplier 'pj' type, at least company_name is required")
      end

      it "type_supplier is pf and document is invalid" do
        invalid_supplier = build(:supplier, document: "81231233123")

        expect(invalid_supplier).not_to be_valid
        expect(invalid_supplier.errors[:document]).to include("must be a valid CPF")
      end

      it "type_supplier is pj and document is invalid" do
        invalid_supplier = build(:supplier, :pj, document: "8123je1233123")

        expect(invalid_supplier).not_to be_valid
        expect(invalid_supplier.errors[:document]).to include("must be a valid CNPJ")
      end

      it "active value is invalid" do
        invalid_supplier = build(:supplier, active: nil)

        expect(invalid_supplier).not_to be_valid
        expect(invalid_supplier.errors[:active]).to include("is not included in the list")
      end

      it "supplier_type value is invalid" do
        expect { build(:supplier, type_supplier: 3) }.to raise_error(ArgumentError)
      end
    end

    context "when have nil values in required attributes" do
      it "type_supplier is nil" do
        invalid_supplier = build(:supplier, type_supplier: nil)

        expect(invalid_supplier).not_to be_valid
        expect(invalid_supplier.errors[:type_supplier]).to include("can't be blank")
      end

      it "type_supplier is nil" do
        invalid_supplier = build(:supplier, document: nil)

        expect(invalid_supplier).not_to be_valid
        expect(invalid_supplier.errors[:document]).to include("can't be blank")
      end

      it "type_supplier is nil" do
        invalid_supplier = build(:supplier, created_by: nil)

        expect(invalid_supplier).not_to be_valid
        expect(invalid_supplier.errors[:created_by]).to include("can't be blank")
      end
    end
  end

  describe "update supplier" do
    let!(:supplier) { create(:supplier) }
    context "when update is valid" do
      it "update name" do
        expect { supplier.update(name: "other_name") }.to change(supplier, :name).from(supplier.name).to("other_name")
      end

      it "update active" do
        expect { supplier.update(active: false) }.to change(supplier, :active).from(true).to(false)
      end

      it "update company_name" do
        create(:supplier, :pj)
        expect { supplier.update(company_name: "other_name") }.to change(supplier, :company_name).from(supplier.company_name).to("other_name")
      end

      it "update company_name" do
        create(:supplier, :pj)
        expect { supplier.update(company_name: "other_name") }.to change(supplier, :company_name).from(supplier.company_name).to("other_name")
      end
    end

    context "when try update attributes only read" do
      it "try update created_by" do
        user = create(:user)
        expect { supplier.update(created_by: user) }.to raise_error(ActiveRecord::ReadonlyAttributeError)
      end

      it "try update document" do
        expect { supplier.update(document: "other_value") }.to raise_error(ActiveRecord::ReadonlyAttributeError)
      end

      it "try update type_supplier" do
        expect { supplier.update(type_supplier: 1) }.to raise_error(ActiveRecord::ReadonlyAttributeError)
      end
    end

    context "when update is invalid" do
      it "update company_name to pf supplier" do
        supplier.update(company_name: "no_nil")

        expect(supplier).not_to be_valid
        expect(supplier.errors[:type_supplier]).to include("from pf supplier, only name is required")
      end

      it "update fantasy_name to pf supplier" do
        supplier.update(fantasy_name: "no_nil")

        expect(supplier).not_to be_valid
        expect(supplier.errors[:type_supplier]).to include("from pf supplier, only name is required")
      end

      it "update name to pj supplier" do
        supplier = create(:supplier, :pj)

        supplier.update(name: "no_nil")

        expect(supplier).not_to be_valid
        expect(supplier.errors[:type_supplier]).to include("to supplier 'pj' type, at least company_name is required")
      end

      it "update active to nil" do
        supplier.update(active: nil)

        expect(supplier).not_to be_valid
        expect(supplier.errors[:active]).to include("is not included in the list")
      end
    end
  end
end
