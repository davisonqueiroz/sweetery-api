require 'rails_helper'

RSpec.describe "RegistrationControllers", type: :request do
  describe "POST /signup" do
    let!(:user) { build(:user) }
    it "valid params to signup" do
      post "/signup", params: { user: { email: user.email, password: user.password, password_confirmation: user.password } }

      expect(response).to have_http_status(200)
    end

    it "email already exists" do
      user = create(:user)

      post "/signup", params: { user: { email: user.email, password: user.password, password_confirmation: user.password } }

      expect(response).to have_http_status(422)
    end

    it "password not have mininum lenght" do
      post "/signup", params: { user: { email: user.email, password: "pass", password_confirmation: "pass" } }

      expect(response).to have_http_status(422)
    end
  end
end
