module Api
  module V1
    class TasksController < ApplicationController
      before_action :set_task, only: [ :update, :destroy ]
      before_action :set_project, only: [ :create, :reorder ]

      # POST /api/v1/projects/:project_id/tasks
      def create
        max_position = @project.tasks.maximum(:position) || -1
        @task = @project.tasks.new(task_params.merge(position: max_position + 1))

        if @task.save
          render json: @task, status: :created
        else
          render json: { errors: @task.errors.full_messages }, status: :unprocessable_content
        end
      end

      # PUT /api/v1/tasks/:id
      def update
        if @task.update(task_params)
          render json: @task
        else
          render json: { errors: @task.errors.full_messages }, status: :unprocessable_content
        end
      end

      # DELETE /api/v1/tasks/:id
      def destroy
        @task.destroy
        head :no_content
      end

      # POST /api/v1/projects/:project_id/tasks/reorder
      def reorder
        task_ids = params[:task_ids]
        return head :bad_request unless task_ids.is_a?(Array)

        task_ids.each_with_index do |task_id, index|
          task = @project.tasks.find_by(id: task_id)
          task&.update_column(:position, index)
        end

        render json: { success: true }
      end

      private

      def set_task
        @task = Task.joins(:project).where(projects: { user_id: current_user.id }).find(params[:id])
      end

      def set_project
        @project = current_user.projects.find(params[:project_id])
      end

      def task_params
        params.require(:task).permit(:title, :completed, :position)
      end
    end
  end
end
