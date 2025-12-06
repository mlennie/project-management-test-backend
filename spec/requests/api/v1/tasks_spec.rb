require 'rails_helper'

RSpec.describe "Api::V1::Tasks", type: :request do
  let!(:project) { create(:project) }
  let!(:tasks) { create_list(:task, 3, project: project) }
  let(:task) { tasks.first }
  let(:task_id) { task.id }

  describe "POST /api/v1/projects/:project_id/tasks" do
    let(:valid_attributes) { { task: { title: "New Task" } } }
    let(:invalid_attributes) { { task: { title: "" } } }

    context "with valid parameters" do
      before { post "/api/v1/projects/#{project.id}/tasks", params: valid_attributes }

      it "creates a new task" do
        expect(json_response['title']).to eq("New Task")
      end

      it "associates task with project" do
        expect(json_response['project_id']).to eq(project.id)
      end

      it "defaults completed to false" do
        expect(json_response['completed']).to eq(false)
      end

      it "returns status code 201" do
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid parameters" do
      before { post "/api/v1/projects/#{project.id}/tasks", params: invalid_attributes }

      it "returns status code 422" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns validation errors" do
        expect(json_response['errors']).to be_present
      end
    end
  end

  describe "PUT /api/v1/tasks/:id" do
    let(:valid_attributes) { { task: { title: "Updated Task", completed: true } } }
    let(:invalid_attributes) { { task: { title: "" } } }

    context "with valid parameters" do
      before { put "/api/v1/tasks/#{task_id}", params: valid_attributes }

      it "updates the task" do
        expect(json_response['title']).to eq("Updated Task")
        expect(json_response['completed']).to eq(true)
      end

      it "returns status code 200" do
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid parameters" do
      before { put "/api/v1/tasks/#{task_id}", params: invalid_attributes }

      it "returns status code 422" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "toggling completed status" do
      before { put "/api/v1/tasks/#{task_id}", params: { task: { completed: true } } }

      it "toggles the completed status" do
        expect(json_response['completed']).to eq(true)
      end
    end
  end

  describe "DELETE /api/v1/tasks/:id" do
    it "deletes the task" do
      expect {
        delete "/api/v1/tasks/#{task_id}"
      }.to change(Task, :count).by(-1)
    end

    it "returns status code 204" do
      delete "/api/v1/tasks/#{task_id}"
      expect(response).to have_http_status(:no_content)
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end

