require 'rails_helper'

RSpec.describe User, type: :model do
  describe " create user" do
    let!(:user) { create(:user) }
    context "when creation is sucesfull" do
      it "creates a user" do
        expect(user).to be_valid
      end
    end
    context "when creation are not sucesfull" do
      it "not have email" do
      user = build(:user, email: nil)
      expect(user).to be_invalid
      expect(user.errors[:email]).to include("can't be blank")
      end

      it "email already in use" do
        duplicated_user = build(:user)
        expect(duplicated_user).to be_invalid
        expect(duplicated_user.errors[:email]).to include("has already been taken")
      end

      it "password_confirmation different from password" do
        user = build(:user, password_confirmation: "other_password")
        expect(user).to be_invalid
        expect(user.errors[:password_confirmation]).to include("doesn't match Password")
      end
    end
  end
end
