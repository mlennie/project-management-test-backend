# Project Management API - Backend

A Ruby on Rails 8.1.1 API-only application for managing projects and tasks.

## 🛠️ Technology Stack

- **Ruby**: 3.4.0+
- **Rails**: 8.1.1 (API-only)
- **Database**: PostgreSQL 17
- **Testing**: RSpec (unit + integration + request specs)
- **Linting**: RuboCop (Rails Omakase)
- **Serialization**: ActiveModel::Serializer / Jbuilder
- **Authentication**: Devise/JWT (Phase 3)

## 📋 Prerequisites

- Docker
- Docker Compose

## 🚀 Getting Started

### 1. Clone the repository

```bash
git clone <your-backend-repo-url>
cd project-management-backend
```

### 2. Start the application

From the backend directory, run:

```bash
docker compose up
```

This will start:
- PostgreSQL database (port 5432)
- Rails API server (port 3000)
- React frontend (port 5173) - from sibling frontend directory

### 3. Access the API

- API Base URL: http://localhost:3000
- Health Check: http://localhost:3000/up
- Hello World: http://localhost:3000/api/v1/hello

## 🧪 Running Tests

### Run all tests

```bash
docker compose exec -e RAILS_ENV=test api bundle exec rspec --format progress --fail-fast
```

### Run specific test file

```bash
docker compose exec -e RAILS_ENV=test api bundle exec rspec spec/requests/api/v1/hello_spec.rb
```

### Run with documentation format

```bash
docker compose exec -e RAILS_ENV=test api bundle exec rspec --format documentation
```

## 🔍 Code Quality

### Run RuboCop

```bash
docker compose exec api bundle exec rubocop
```

### Auto-fix RuboCop issues

```bash
docker compose exec api bundle exec rubocop -a
```

## 🗄️ Database Commands

### Create database

```bash
docker compose exec api bundle exec rails db:create
```

### Run migrations

```bash
docker compose exec api bundle exec rails db:migrate
```

### Seed database

```bash
docker compose exec api bundle exec rails db:seed
```

### Reset database

```bash
docker compose exec api bundle exec rails db:reset
```

## 📡 API Endpoints

### Phase 1: Hello World

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/hello` | Returns hello world message |

### Phase 2: Projects & Tasks (Coming Soon)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/projects` | List all projects |
| GET | `/api/v1/projects/:id` | Get project with tasks |
| POST | `/api/v1/projects` | Create a project |
| PUT | `/api/v1/projects/:id` | Update a project |
| DELETE | `/api/v1/projects/:id` | Delete a project |
| POST | `/api/v1/projects/:project_id/tasks` | Add task to project |
| PUT | `/api/v1/tasks/:id` | Update task |
| DELETE | `/api/v1/tasks/:id` | Delete task |

## 📁 Project Structure

```
backend/
├── app/
│   ├── controllers/
│   │   └── api/
│   │       └── v1/
│   │           └── hello_controller.rb
│   ├── models/
│   └── ...
├── config/
│   ├── routes.rb
│   ├── database.yml
│   └── initializers/
│       └── cors.rb
├── db/
│   ├── migrate/
│   └── seeds.rb
├── spec/
│   ├── requests/
│   └── rails_helper.rb
├── Dockerfile
├── docker-compose.yml
└── Gemfile
```

## 🔧 Development

### Access Rails console

```bash
docker compose exec api bundle exec rails console
```

### Access container shell

```bash
docker compose exec api bash
```

### View logs

```bash
docker compose logs -f api
```

### Install new gem

1. Add gem to `Gemfile`
2. Run:
```bash
docker compose exec api bundle install
```

## 🌐 CORS Configuration

The API accepts requests from:
- `http://localhost:5173` (React frontend)

To add more origins, edit `config/initializers/cors.rb`

## 🔐 Environment Variables

The application uses the following environment variables:

| Variable | Default | Description |
|----------|---------|-------------|
| `DB_HOST` | `db` | Database host |
| `DB_USERNAME` | `postgres` | Database username |
| `DB_PASSWORD` | `postgres` | Database password |
| `DB_PORT` | `5432` | Database port |
| `RAILS_ENV` | `development` | Rails environment |

## 📝 Testing Strategy

- **Unit tests**: Model validations, associations, methods
- **Integration tests**: Complex workflows across multiple models
- **Request specs**: API endpoints, responses, status codes
- **No controller specs**: Using request specs instead (Rails best practice)
- **No E2E tests**: Frontend handles E2E testing

## 🔄 Continuous Integration

GitHub Actions automatically runs on every push:
- RuboCop linting
- RSpec test suite
- Database setup and migrations

See `.github/workflows/test.yml` for details.

## 📚 Additional Resources

- [Rails Guides](https://guides.rubyonrails.org/)
- [RSpec Documentation](https://rspec.info/)
- [RuboCop Rails](https://docs.rubocop.org/rubocop-rails/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

## 🤝 Contributing

1. Create a feature branch
2. Make your changes
3. Ensure tests pass: `docker compose exec -e RAILS_ENV=test api bundle exec rspec`
4. Ensure RuboCop passes: `docker compose exec api bundle exec rubocop`
5. Commit your changes
6. Push to the branch
7. Create a Pull Request

## 📄 License

This project is part of a technical assessment.
