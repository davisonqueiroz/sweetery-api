require 'rails_helper'

RSpec.describe Permission, type: :model do
  describe "create permission" do
    let!(:permission) { create(:permission) }
    context "when creation is sucessfull" do
      it "creates a permission" do
        expect(permission).to be_valid
      end

      it "creates a permission with different resource" do
        permission = create(:permission, resource: "service")

        expect(permission).to be_valid
      end

      it "creates a permission with different action" do
        permission = create(:permission, action: "write")

        expect(permission).to be_valid
      end

      it "creates a permission with uppercases" do
        permission = create(:permission, action: "WriTe", resource: "SErvIcE")

        expect(permission).to be_valid

        expect(permission.action).to match("write")
        expect(permission.resource).to match("service")
      end
    end

    context "when creation is invalid" do
      it "resource is nil" do
        permission = build(:permission, resource: nil)

        expect(permission).to be_invalid
        expect(permission.errors[:resource]).to include("can't be blank")
      end

      it "action is nil" do
        permission = build(:permission, action: nil)

        expect(permission).to be_invalid
        expect(permission.errors[:action]).to include("can't be blank")
      end

      it "resource and action index already exists" do
        duplicated_permission = build(:permission, resource: permission.resource, action: permission.action)
        expect(duplicated_permission).to be_invalid
        expect(duplicated_permission.errors[:resource]).to include("has already been taken")
      end

      it "doesn't allow duplicated resource with different case" do
        duplicated_permission = build(:permission, resource: permission.resource.upcase, action: permission.action)

        expect(duplicated_permission).to be_invalid
        expect(duplicated_permission.errors[:resource]).to include("has already been taken")
      end

      it "doesn't allow duplicated action with different case" do
        duplicated_permission = build(:permission, resource: permission.resource, action: permission.action.upcase)

        expect(duplicated_permission).to be_invalid
        expect(duplicated_permission.errors[:resource]).to include("has already been taken")
      end
    end
  end

  describe "update permission attributes" do
    let!(:permission) { create(:permission) }
    context "when is valid" do
      it "update description " do
        expect { permission.update(description: "edited for test") }.to change(permission, :description).from("Can read stock").to("edited for test")
      end
    end

    context "when is not valid" do
      it "update action on created permission" do
        expect { permission.update(action: "write") }.to raise_error(ActiveRecord::ReadonlyAttributeError)
      end

      it "update resource on created permission" do
        expect { permission.update(resource: "service") }.to raise_error(ActiveRecord::ReadonlyAttributeError)
      end
    end
  end
end
