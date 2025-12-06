class ApplicationController < ActionController::API
  before_action :authenticate_user!

  attr_reader :current_user

  private

  def authenticate_user!
    token = bearer_token
    return render_unauthorized("Missing token") unless token

    begin
      payload = decode_token(token)
      @current_user = User.find(payload["sub"])
    rescue ActiveRecord::RecordNotFound
      render_unauthorized("User not found")
    rescue JWT::DecodeError => e
      render_unauthorized("Invalid token: #{e.message}")
    rescue JWT::ExpiredSignature
      render_unauthorized("Token has expired")
    end
  end

  def bearer_token
    auth_header = request.headers["Authorization"]
    return nil unless auth_header&.start_with?("Bearer ")

    auth_header.split(" ").last
  end

  def decode_token(token)
    JWT.decode(token, jwt_secret, true, { algorithm: "HS256" }).first
  end

  def encode_token(payload)
    JWT.encode(payload.merge(exp: 24.hours.from_now.to_i), jwt_secret, "HS256")
  end

  def jwt_secret
    Rails.application.credentials.secret_key_base || ENV["SECRET_KEY_BASE"]
  end

  def render_unauthorized(message = "Unauthorized")
    render json: { error: message }, status: :unauthorized
  end
end
