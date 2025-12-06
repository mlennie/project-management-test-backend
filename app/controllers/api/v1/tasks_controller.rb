module Api
  module V1
    class TasksController < ApplicationController
      before_action :set_task, only: [ :update, :destroy ]
      before_action :set_project, only: [ :create ]

      # POST /api/v1/projects/:project_id/tasks
      def create
        @task = @project.tasks.new(task_params)

        if @task.save
          render json: @task, status: :created
        else
          render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PUT /api/v1/tasks/:id
      def update
        if @task.update(task_params)
          render json: @task
        else
          render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/tasks/:id
      def destroy
        @task.destroy
        head :no_content
      end

      private

      def set_task
        @task = Task.find(params[:id])
      end

      def set_project
        @project = Project.find(params[:project_id])
      end

      def task_params
        params.require(:task).permit(:title, :completed)
      end
    end
  end
end
