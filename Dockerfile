FROM ruby:3.4

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
  postgresql-client \
  build-essential \
  libpq-dev \
  nodejs \
  && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy the rest of the application
COPY . .

# Expose port 3000
EXPOSE 3000

# Start the server
CMD ["bash", "-c", "rm -f tmp/pids/server.pid && bundle exec rails db:prepare && bundle exec rails server -b 0.0.0.0"]
