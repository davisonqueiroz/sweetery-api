require 'rails_helper'

RSpec.describe RolePermission, type: :model do
  describe "create role permission" do
    let!(:role_permission) { create(:role_permission) }
    context "when creation is sucessfull" do
      it "create role permission" do
        expect(role_permission).to be_valid
      end

      it "create role_permission with other permission" do
        permission = create(:permission)
        new_role_permission = create(:role_permission, permission: permission)
        expect(new_role_permission).to be_valid
      end

      it "create role_permission with other role" do
        role = create(:role)
        new_role_permission = create(:role_permission, role: role)
        expect(new_role_permission).to be_valid
      end
    end

    context "when create are invalid" do
      it "combination of role and permission already exists" do
        duplicated_role_permission = build(:role_permission, role: role_permission.role, permission: role_permission.permission)

        expect(duplicated_role_permission).to be_invalid
        expect(duplicated_role_permission.errors["role"]).to include("has already been taken")
      end

      it "role are nil" do
        invalid_role_permission = build(:role_permission, role: nil)

        expect(invalid_role_permission).to be_invalid
        expect(invalid_role_permission.errors["role"]).to include("can't be blank")
      end

      it "permission are nil" do
        invalid_role_permission = build(:role_permission, permission: nil)

        expect(invalid_role_permission).to be_invalid
        expect(invalid_role_permission.errors["permission"]).to include("can't be blank")
      end
    end
  end

  describe "update role_permission attributes" do
    let!(:role_permission) { create(:role_permission) }
    context "when is not valid" do
      it "update role" do
        role = create(:role)

        expect { role_permission.update(role: role) }.to raise_error(ActiveRecord::ReadonlyAttributeError)
      end

      it "update permission" do
        permission = create(:permission)

        expect { role_permission.update(permission: permission) }.to raise_error(ActiveRecord::ReadonlyAttributeError)
      end
    end
  end
end
