# Allow all hosts in test environment
if Rails.env.test?
  # Create a permissive permissions policy for testing
  Rails.application.config.hosts.clear
end




