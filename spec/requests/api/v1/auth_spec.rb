require 'rails_helper'

RSpec.describe "Api::V1::Auth", type: :request do
  before { host! "localhost" }

  let(:password) { "Password123" }
  let(:user) { create(:user, password: password, password_confirmation: password) }

  describe "POST /api/v1/auth/register" do
    it "creates a user and returns token" do
      post "/api/v1/auth/register", params: { user: { email: "new@example.com", password: password, password_confirmation: password } }

      expect(response).to have_http_status(:created), response.body
      body = JSON.parse(response.body)
      expect(body["token"]).to be_present
      expect(body["user"]["email"]).to eq("new@example.com")
    end

    it "returns errors for invalid data" do
      post "/api/v1/auth/register", params: { user: { email: "", password: "short", password_confirmation: "short" } }

      expect(response).to have_http_status(:unprocessable_content), response.body
    end
  end

  describe "POST /api/v1/auth/login" do
    it "authenticates a user and returns token" do
      post "/api/v1/auth/login", params: { email: user.email, password: password }

      expect(response).to have_http_status(:ok), response.body
      body = JSON.parse(response.body)
      expect(body["token"]).to be_present
      expect(body["user"]["email"]).to eq(user.email)
    end

    it "rejects invalid credentials" do
      post "/api/v1/auth/login", params: { email: user.email, password: "wrong" }

      expect(response).to have_http_status(:unauthorized), response.body
    end
  end

  describe "GET /api/v1/auth/me" do
    it "returns current user when authorized" do
      secret = Rails.application.credentials.secret_key_base || ENV["SECRET_KEY_BASE"]
      token = JWT.encode({ sub: user.id, exp: 24.hours.from_now.to_i }, secret, 'HS256')
      get "/api/v1/auth/me", headers: { "Authorization" => "Bearer #{token}" }

      expect(response).to have_http_status(:ok), response.body
      body = JSON.parse(response.body)
      expect(body["user"]["email"]).to eq(user.email)
    end

    it "returns unauthorized without token" do
      get "/api/v1/auth/me"
      expect(response).to have_http_status(:unauthorized), response.body
    end
  end
end
