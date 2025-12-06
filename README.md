# Project Management App - Backend API

Ruby on Rails 8.1.1 API-only application for managing projects and tasks with user authentication.

## 🚀 Tech Stack

- **Framework**: Ruby on Rails 8.1.1 (API-only mode)
- **Ruby**: 3.4.0+
- **Database**: PostgreSQL 17
- **Authentication**: JWT with bcrypt
- **Testing**: RSpec (unit, integration, request specs)
- **Security**: Rack::Attack for rate limiting
- **Container**: Docker

## 📋 Features

- **Authentication**: JWT-based auth with registration, login, logout
- **Projects**: Full CRUD operations scoped to authenticated users
- **Tasks**: Create, update, delete, toggle completion, drag-to-reorder
- **Rate Limiting**: API throttling to prevent abuse
- **N+1 Query Optimization**: Eager loading with `includes`
- **Error Handling**: Consistent JSON error responses
- **CORS**: Configured for frontend access

## 🗄️ Database Schema

### Users
```ruby
- id: integer (primary key)
- email: string (unique, required)
- password_digest: string (required)
- created_at: datetime
- updated_at: datetime
```

### Projects
```ruby
- id: integer (primary key)
- name: string (required)
- description: text
- user_id: integer (foreign key, required)
- created_at: datetime
- updated_at: datetime
```

### Tasks
```ruby
- id: integer (primary key)
- title: string (required)
- completed: boolean (default: false)
- position: integer (default: 0)
- project_id: integer (foreign key, required)
- created_at: datetime
- updated_at: datetime
```

## 🔌 API Endpoints

### Authentication (`/api/v1/auth`)

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/auth/register` | Register new user | No |
| POST | `/auth/login` | Login and get JWT token | No |
| GET | `/auth/me` | Get current user | Yes |
| DELETE | `/auth/logout` | Logout (client-side token removal) | Yes |

### Projects (`/api/v1/projects`)

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/projects` | List all user's projects | Yes |
| GET | `/projects/:id` | Get project with tasks | Yes |
| POST | `/projects` | Create new project | Yes |
| PUT | `/projects/:id` | Update project | Yes |
| DELETE | `/projects/:id` | Delete project | Yes |

### Tasks (`/api/v1/tasks`)

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/projects/:project_id/tasks` | Create task | Yes |
| PUT | `/tasks/:id` | Update task | Yes |
| DELETE | `/tasks/:id` | Delete task | Yes |
| POST | `/projects/:project_id/tasks/reorder` | Reorder tasks | Yes |

## 🔐 Authentication

All protected endpoints require a JWT token in the Authorization header:

```
Authorization: Bearer <your_jwt_token>
```

### Request/Response Examples

**Register:**
```bash
POST /api/v1/auth/register
Content-Type: application/json

{
  "user": {
    "email": "user@example.com",
    "password": "Password123",
    "password_confirmation": "Password123"
  }
}

# Response (201):
{
  "token": "eyJhbGciOiJIUzI1NiJ9...",
  "user": {
    "id": 1,
    "email": "user@example.com"
  }
}
```

**Login:**
```bash
POST /api/v1/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "Password123"
}

# Response (200):
{
  "token": "eyJhbGciOiJIUzI1NiJ9...",
  "user": {
    "id": 1,
    "email": "user@example.com"
  }
}
```

**Create Project:**
```bash
POST /api/v1/projects
Authorization: Bearer <token>
Content-Type: application/json

{
  "project": {
    "name": "My Project",
    "description": "Project description"
  }
}

# Response (201):
{
  "id": 1,
  "name": "My Project",
  "description": "Project description",
  "user_id": 1,
  "created_at": "2025-12-06T00:00:00.000Z",
  "updated_at": "2025-12-06T00:00:00.000Z"
}
```

## 🚦 Rate Limiting

The API implements rate limiting to prevent abuse:

- **General requests**: 300 requests per 5 minutes per IP
- **Login attempts**: 5 attempts per 20 seconds per IP/email
- **Registration**: 3 attempts per 20 seconds per IP

Rate-limited requests receive a `429 Too Many Requests` response.

## 🛠️ Setup & Installation

### Prerequisites

- Docker
- Docker Compose

### Environment Variables

Create `.env` file (optional, defaults are set):

```env
DATABASE_URL=postgresql://postgres:password@db:5432/app_development
SECRET_KEY_BASE=your_secret_key_base
```

### Installation

1. **Start services:**
   ```bash
   docker compose up
   ```

2. **Setup database:**
   ```bash
   docker compose exec api bundle exec rails db:create db:migrate db:seed
   ```

3. **API available at:** http://localhost:3000

### Seeded Data

The database seeds include:
- Demo user: `demo@example.com` / `Password123`
- 3 sample projects with 9 tasks

## 🧪 Testing

### Run All Tests
```bash
docker compose exec api bundle exec rspec
```

### Run with Documentation Format
```bash
docker compose exec api bundle exec rspec --format documentation
```

### Run Specific Spec
```bash
docker compose exec api bundle exec rspec spec/requests/api/v1/projects_spec.rb
```

### Test Coverage
- **49 specs** covering:
  - Model validations and associations
  - Authentication flows
  - All API endpoints
  - Authorization (user-scoped data)
  - Task reordering

## 🎨 Code Quality

### Run RuboCop
```bash
docker compose exec api bundle exec rubocop
```

### Auto-fix Issues
```bash
docker compose exec api bundle exec rubocop -a
```

## 📦 Project Structure

```
backend/
├── app/
│   ├── controllers/
│   │   └── api/v1/         # API controllers
│   └── models/             # ActiveRecord models
├── config/
│   ├── initializers/
│   │   ├── cors.rb         # CORS configuration
│   │   └── rack_attack.rb  # Rate limiting
│   └── routes.rb           # API routes
├── db/
│   ├── migrate/            # Database migrations
│   ├── seeds.rb            # Seed data
│   └── schema.rb           # Database schema
├── spec/
│   ├── factories/          # Test factories
│   ├── models/             # Model specs
│   └── requests/           # Request specs
├── Dockerfile
├── Gemfile
└── README.md
```

## 🔧 Development

### Rails Console
```bash
docker compose exec api bundle exec rails console
```

### Generate Migration
```bash
docker compose exec api bundle exec rails generate migration MigrationName
```

### Run Migration
```bash
docker compose exec api bundle exec rails db:migrate
```

### Rollback Migration
```bash
docker compose exec api bundle exec rails db:rollback
```

## 🐛 Troubleshooting

### Reset Database
```bash
docker compose exec api bundle exec rails db:drop db:create db:migrate db:seed
```

### View Logs
```bash
docker compose logs -f api
```

### Rebuild Container
```bash
docker compose build api
docker compose up
```

## 📝 Notes

- API is versioned under `/api/v1`
- All endpoints return JSON
- Authentication tokens expire after 24 hours
- Projects and tasks are scoped to authenticated users
- Deleting a project cascades to its tasks

## 🌐 Production Deployment

### Live URLs

- **Production API**: https://project-mgmt-api-2cf73f8e0744.herokuapp.com
- **API Base URL**: https://project-mgmt-api-2cf73f8e0744.herokuapp.com/api/v1
- **Frontend URL**: https://frontend-ki5m88e36-dealais-projects.vercel.app
- **Platform**: Heroku (backend), Vercel (frontend)

### Demo Account

Login to the production app:
- **Email**: `demo@example.com`
- **Password**: `Password123`

### Testing Production API

**Health Check:**
```bash
curl https://project-mgmt-api-2cf73f8e0744.herokuapp.com/api/v1/hello
# Returns: {"message":"Hello World"}
```

**Login:**
```bash
curl -X POST https://project-mgmt-api-2cf73f8e0744.herokuapp.com/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"demo@example.com","password":"Password123"}'

# Save the token from response
TOKEN="<your_token_here>"
```

**Get Projects:**
```bash
curl https://project-mgmt-api-2cf73f8e0744.herokuapp.com/api/v1/projects \
  -H "Authorization: Bearer $TOKEN"
```

**Create Project:**
```bash
curl -X POST https://project-mgmt-api-2cf73f8e0744.herokuapp.com/api/v1/projects \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"project":{"name":"Test Project","description":"Created via API"}}'
```

### Deployment Details

**Heroku Configuration:**
- Database: PostgreSQL Essential-0 plan
- Environment: Production
- Migrations: Auto-run on release
- CORS: Configured for Vercel frontend

**Environment Variables:**
```bash
# View all config vars
heroku config --app project-mgmt-api

# Set new variable
heroku config:set VARIABLE_NAME=value --app project-mgmt-api
```

**Database Management:**
```bash
# Seed production database
heroku run bundle exec rails db:seed --app project-mgmt-api

# Run migrations
heroku run bundle exec rails db:migrate --app project-mgmt-api

# Open Rails console
heroku run bundle exec rails console --app project-mgmt-api

# Reset database (CAUTION!)
heroku run bundle exec rails db:reset --app project-mgmt-api
```

**Monitoring:**
```bash
# View logs
heroku logs --tail --app project-mgmt-api

# View only app logs
heroku logs --source app --tail --app project-mgmt-api

# Check dyno status
heroku ps --app project-mgmt-api
```

## 🚀 Production Considerations

- ✅ `SECRET_KEY_BASE` environment variable configured
- ✅ Production database (PostgreSQL) configured
- ✅ HTTPS enabled via Heroku
- ✅ Rate limits configured (300 req/5min)
- 🔲 Set up monitoring and logging (e.g., Sentry)
- 🔲 Consider Redis for Rack::Attack cache for multi-dyno setups
