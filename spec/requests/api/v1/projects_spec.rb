require 'rails_helper'

RSpec.describe "Api::V1::Projects", type: :request do
  before { host! "localhost" }

  let(:user) { create(:user) }
  let(:headers) { { "Authorization" => "Bearer #{token}" } }
  let(:jwt_secret) { Rails.application.credentials.secret_key_base || ENV["SECRET_KEY_BASE"] }
  let(:token) { JWT.encode({ sub: user.id, exp: 24.hours.from_now.to_i }, jwt_secret, 'HS256') }
  let!(:projects) { create_list(:project, 3, user: user) }
  let(:project) { projects.first }
  let(:project_id) { project.id }

  describe "GET /api/v1/projects" do
    before { get "/api/v1/projects", headers: headers }

    it "returns all projects" do
      expect(json_response.size).to eq(3)
    end

    it "returns status code 200" do
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /api/v1/projects/:id" do
    let!(:tasks) { create_list(:task, 2, project: project) }

    before { get "/api/v1/projects/#{project_id}", headers: headers }

    context "when project exists" do
      it "returns the project" do
        expect(json_response['id']).to eq(project_id)
      end

      it "includes associated tasks" do
        expect(json_response['tasks'].size).to eq(2)
      end

      it "returns status code 200" do
        expect(response).to have_http_status(:success)
      end
    end

    context "when project does not exist" do
      let(:project_id) { 0 }

      it "returns status code 404" do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /api/v1/projects" do
    let(:valid_attributes) { { project: { name: "New Project", description: "Description" } } }
    let(:invalid_attributes) { { project: { name: "", description: "Description" } } }

    context "with valid parameters" do
      before { post "/api/v1/projects", params: valid_attributes, headers: headers }

      it "creates a new project" do
        expect(json_response['name']).to eq("New Project")
      end

      it "returns status code 201" do
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid parameters" do
      before { post "/api/v1/projects", params: invalid_attributes, headers: headers }

      it "returns status code 422" do
        expect(response).to have_http_status(:unprocessable_content)
      end

      it "returns validation errors" do
        expect(json_response['errors']).to be_present
      end
    end
  end

  describe "PUT /api/v1/projects/:id" do
    let(:valid_attributes) { { project: { name: "Updated Project" } } }
    let(:invalid_attributes) { { project: { name: "" } } }

    context "with valid parameters" do
      before { put "/api/v1/projects/#{project_id}", params: valid_attributes, headers: headers }

      it "updates the project" do
        expect(json_response['name']).to eq("Updated Project")
      end

      it "returns status code 200" do
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid parameters" do
      before { put "/api/v1/projects/#{project_id}", params: invalid_attributes, headers: headers }

      it "returns status code 422" do
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "DELETE /api/v1/projects/:id" do
    it "deletes the project" do
      expect {
        delete "/api/v1/projects/#{project_id}", headers: headers
      }.to change(Project, :count).by(-1)
    end

    it "returns status code 204" do
      delete "/api/v1/projects/#{project_id}", headers: headers
      expect(response).to have_http_status(:no_content)
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end
