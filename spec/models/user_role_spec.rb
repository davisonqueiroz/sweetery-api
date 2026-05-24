require 'rails_helper'

RSpec.describe UserRole, type: :model do
  describe "create user role" do
    let!(:user_role) { create(:user_role) }
    context "when creation is sucessfull" do
      it "create user role" do
        expect(user_role).to be_valid
      end

      it "create user with other role" do
        role = create(:role)
        user_role = create(:user_role, role: role)
        expect(user_role). to be_valid
      end

      it "create user_role with other user" do
        user = create(:user)
        user_role = create(:user_role, user: user)
        expect(user_role). to be_valid
      end
    end

    context "when create are invalid" do
      it "combination of user and role already exists" do
        duplicated_user_role = build(:user_role, user: user_role.user, role: user_role.role)

        expect(duplicated_user_role).to be_invalid
        expect(duplicated_user_role.errors["user"]).to include("has already been taken")
      end

      it "user are nil" do
        invalid_user_role = build(:user_role, user: nil)

        expect(invalid_user_role).to be_invalid
        expect(invalid_user_role.errors["user"]).to include("can't be blank")
      end

      it "role are nil" do
        invalid_user_role = build(:user_role, role: nil)

        expect(invalid_user_role).to be_invalid
        expect(invalid_user_role.errors["role"]).to include("can't be blank")
      end
    end
  end

  describe "update user_role attributes" do
    let!(:user_role) { create(:user_role) }
    context "when is not valid" do
      it "update user" do
        user = create(:user)

        expect { user_role.update(user: user) }.to raise_error(ActiveRecord::ReadonlyAttributeError)
      end

      it "update role" do
        role = create(:role)

        expect { user_role.update(role: role) }.to raise_error(ActiveRecord::ReadonlyAttributeError)
      end

      it "update created_by" do
        user = create(:user)

        expect { user_role.update(created_by_id: user.id) }.to raise_error(ActiveRecord::ReadonlyAttributeError)
      end
    end
  end
end
