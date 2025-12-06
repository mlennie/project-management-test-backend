require 'rails_helper'

RSpec.describe "Api::V1::Hello", type: :request do
  before { host! "localhost" }

  describe "GET /api/v1/hello" do
    it "returns hello world message" do
      get "/api/v1/hello", headers: { 'Accept' => 'application/json' }

      expect(response).to have_http_status(:success)

      json_response = JSON.parse(response.body)
      expect(json_response["message"]).to eq("Hello World")
    end

    it "returns JSON content type" do
      get "/api/v1/hello", headers: { 'Accept' => 'application/json' }

      expect(response.content_type).to match(/application\/json/)
    end
  end
end
