require 'rails_helper'

RSpec.describe Role, type: :model do
  describe "create role" do
    let!(:role) { create(:role) }
    context "when creation is sucessfull" do
      it "creates a role" do
        expect(role).to be_valid
      end

      it "creates a role with uppercases" do
        role = create(:role, name: "AdminIsTratOr")

        expect(role).to be_valid

        expect(role.name).to match("administrator")
      end
    end

    context "when creation is invalid" do
      it "name is nil" do
        role = build(:role, name: nil)

        expect(role).to be_invalid
        expect(role.errors[:name]).to include("can't be blank")
      end

      it "name already exists" do
        duplicated_role = build(:role, name: role.name)

        expect(duplicated_role).to be_invalid
        expect(duplicated_role.errors[:name]).to include("has already been taken")
      end

      it "doesn't allow duplicated name with different case" do
        duplicated_role = build(:role, name: (role.name.upcase))

        expect(duplicated_role).to be_invalid
        expect(duplicated_role.errors[:name]).to include("has already been taken")
      end

      it "active is nil" do
        role = build(:role, active: nil)

        expect(role).to be_invalid
        expect(role.errors[:active]).to include("is not included in the list")
      end
    end
  end

  describe "update role attributes" do
    let!(:role) { create(:role) }
    context "when is valid" do
      it "update active attribute" do
        expect { role.update(active: false) }.to change(role, :active).from(true).to(false)
      end

      it "update description" do
        expect { role.update(description: "new description for role") }.to change(role, :description).from("Role responsable from control of inventory.").to("new description for role")
      end
    end

    context "when is not valid" do
      it "update name on created role" do
        expect { role.update(name: "other_name") }.to raise_error(ActiveRecord::ReadonlyAttributeError)
      end

      it "update created_by on created role" do
        expect { role.update(created_by_id: 2) }.to raise_error(ActiveRecord::ReadonlyAttributeError)
      end
    end
  end
end
