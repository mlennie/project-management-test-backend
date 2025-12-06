module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :authenticate_user!, only: %i[register login]

      def register
        user = User.new(user_params)
        if user.save
          render json: auth_response(user), status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_content
        end
      end

      def login
        user = User.find_by(email: params[:email]&.downcase)
        if user&.authenticate(params[:password])
          render json: auth_response(user), status: :ok
        else
          render json: { error: "Invalid email or password" }, status: :unauthorized
        end
      end

      def me
        render json: { user: user_payload(current_user) }, status: :ok
      end

      def logout
        head :no_content
      end

      private

      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation).tap do |p|
          p[:email] = p[:email].downcase if p[:email]
        end
      end

      def auth_response(user)
        {
          token: encode_token(sub: user.id),
          user: user_payload(user)
        }
      end

      def user_payload(user)
        {
          id: user.id,
          email: user.email,
          created_at: user.created_at,
          updated_at: user.updated_at
        }
      end
    end
  end
end
