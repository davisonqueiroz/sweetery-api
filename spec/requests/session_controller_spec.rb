require 'rails_helper'

RSpec.describe "SessionControllers", type: :request do
  describe "POST /login" do
    let!(:user) { create(:user) }
    context "when the request is sucesfull" do
      it "valid login" do
        post "/login", params: { user: { email: user.email, password: user.password } }

        expect(response).to have_http_status(200)
      end
    end
    context "when request is not sucesfull" do
      it "invalid password" do
        post "/login", params: { user: { email: user.email, password: "pass1234" } }

        expect(response).to have_http_status(401)
      end

      it "invalid email" do
        post "/login", params: { user: { email: "random@email.dev", password: user.password } }

        expect(response).to have_http_status(401)
      end
    end
  end

  describe "DELETE /logout" do
    let!(:user) { create (:user) }
    context "when the request is sucesfull" do
      it "valid logout" do
        post "/login", params: { user: { email: user.email, password: user.password } }

        header = { "Authorization" => "#{response.headers["Authorization"]}" }

        delete "/logout", headers: header

        expect(response).to have_http_status(200)
      end
    end
    context "when the request is not sucesfull" do
      it "not send authorization token" do
        post "/login", params: { user: { email: user.email, password: user.password } }

        delete "/logout"

        expect(response).to have_http_status(401)
      end
    end
  end
end
