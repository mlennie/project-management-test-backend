# frozen_string_literal: true

# Configure Rack::Attack for rate limiting
class Rack::Attack
  # Allow requests from localhost in development
  Rack::Attack.safelist("allow-localhost") do |req|
    req.ip == "127.0.0.1" || req.ip == "::1" || req.ip == "172.18.0.1"
  end

  # Throttle all requests by IP (60rpm)
  throttle("req/ip", limit: 300, period: 5.minutes) do |req|
    req.ip unless req.path.start_with?("/assets")
  end

  # Throttle login attempts by IP address
  throttle("logins/ip", limit: 5, period: 20.seconds) do |req|
    if req.path == "/api/v1/auth/login" && req.post?
      req.ip
    end
  end

  # Throttle login attempts by email
  throttle("logins/email", limit: 5, period: 20.seconds) do |req|
    if req.path == "/api/v1/auth/login" && req.post?
      # Email from POST body
      req.params["email"]&.to_s&.downcase&.gsub(/\s+/, "")
    end
  end

  # Throttle registration attempts
  throttle("registrations/ip", limit: 3, period: 20.seconds) do |req|
    if req.path == "/api/v1/auth/register" && req.post?
      req.ip
    end
  end

  # Response for throttled requests
  self.throttled_responder = lambda do |env|
    retry_after = (env["rack.attack.match_data"] || {})[:period]
    [
      429,
      {
        "Content-Type" => "application/json",
        "Retry-After" => retry_after.to_s
      },
      [ { error: "Too many requests. Please try again later." }.to_json ]
    ]
  end
end
