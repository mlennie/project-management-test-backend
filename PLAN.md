# 📋 Project Management App - Development Plan

## 🎯 Project Overview

Build a full-stack Project Management App with:
- **Backend**: Ruby on Rails 8.1.1 API-only
- **Frontend**: React 18.2.0 with Vite
- **Database**: PostgreSQL 17
- **Infrastructure**: Docker + Docker Compose
- **Testing**: RSpec (backend), Jest (frontend)

---

## 🏗️ Technology Stack

### Backend
- Rails 8.1.1 (API-only)
- Ruby 3.4.0+
- PostgreSQL 17
- RSpec (unit + integration + request specs)
- ActiveModel::Serializer or Jbuilder
- Devise/JWT for authentication
- Docker

### Frontend
- React 18.2.0
- Vite (build tool)
- Material-UI (MUI v5)
- React Router v6
- useReducer for state management
- Jest + React Testing Library
- MSW (Mock Service Worker) for API mocking
- Axios for HTTP requests
- notistack for notifications
- Docker

### Infrastructure
- Docker Compose
- PostgreSQL container
- Development environment fully containerized

---

## 📁 Project Structure

```
project-management-test/
├── backend/              # Separate git repo
│   ├── .git/
│   ├── Dockerfile
│   ├── app/
│   ├── config/
│   ├── db/
│   ├── spec/
│   └── ...
├── frontend/             # Separate git repo
│   ├── .git/
│   ├── Dockerfile
│   ├── src/
│   ├── tests/
│   └── ...
├── docker-compose.yml    # Root orchestration
└── PLAN.md              # This file
```

---

## 🚀 Phase 1: Hello World Application

**Goal:** Create a working Docker-based app where React fetches "Hello World" from the Rails API

### Backend (Rails 8.1.1 API)

**Setup:**
- Initialize Rails 8.1.1 API-only app with PostgreSQL
- Configure for API mode with CORS
- Create `/api/v1/hello` endpoint returning `{ message: "Hello World" }`

**Testing:**
- Set up RSpec with:
  - `rspec-rails`
  - `factory_bot_rails`
  - `shoulda-matchers`
  - `database_cleaner`
- Write request spec for hello endpoint

**Docker:**
- Dockerfile with Ruby 3.4.0+
- Wait for PostgreSQL to be ready
- Port: `3000`

**Git:**
- Initialize git repo in `backend/`

### Frontend (React 18.2.0 + Vite)

**Setup:**
- Initialize React app with Vite
- Install Material-UI (MUI):
  - `@mui/material`
  - `@emotion/react` & `@emotion/styled`
  - `@mui/icons-material`
- Set up MUI theme provider
- Create `HelloWorld` component that fetches from `/api/v1/hello`

**Testing:**
- Set up Jest + React Testing Library:
  - Configure for Vite
  - Write component test for HelloWorld

**Docker:**
- Dockerize React app with Vite
- Port: `5173` (Vite default)

**Git:**
- Initialize git repo in `frontend/`

### Infrastructure

**Docker Compose:**
- Root `docker-compose.yml` with 3 services:
  - `db` (PostgreSQL 17)
  - `api` (Rails - builds from `./backend`)
  - `web` (React - builds from `./frontend`)

**Configuration:**
- CORS configuration in Rails for `http://localhost:5173`
- Environment variables setup
- Docker networking

---

## 📊 Phase 2: Core Project Management Features

**Goal:** Implement full CRUD for Projects and Tasks

### Backend

#### Models

**Project:**
```ruby
- id (primary key)
- name (string, required)
- description (text, optional)
- timestamps
```

**Task:**
```ruby
- id (primary key)
- title (string, required)
- completed (boolean, default: false)
- project_id (foreign key, required)
- timestamps
```

**Associations:**
- Project has_many :tasks (dependent: :destroy)
- Task belongs_to :project

#### API Endpoints (all under `/api/v1`)

| Method | Route | Description |
|--------|-------|-------------|
| GET | `/api/v1/projects` | List all projects |
| GET | `/api/v1/projects/:id` | Get project + tasks |
| POST | `/api/v1/projects` | Create project |
| PUT | `/api/v1/projects/:id` | Update project |
| DELETE | `/api/v1/projects/:id` | Delete project (cascade tasks) |
| POST | `/api/v1/projects/:project_id/tasks` | Add task to project |
| PUT | `/api/v1/tasks/:id` | Update task (toggle completion) |
| DELETE | `/api/v1/tasks/:id` | Delete task |

#### Serializers
- Use ActiveModel::Serializer or Jbuilder
- `ProjectSerializer` (includes associated tasks)
- `TaskSerializer`

#### RSpec Tests
- **Model specs:**
  - Project validations & associations
  - Task validations & associations
- **Request specs** for all 8 endpoints
- **Integration specs** for nested resource creation
- **Factory definitions** for test data

### Frontend

#### Routing Structure (React Router v6)

```
/                           # Home - Project List
/projects/new               # Create New Project
/projects/:id               # Project Detail with Tasks
/projects/:id/edit          # Edit Project
```

#### Component Architecture

```
App.tsx
├── Layout (MUI AppBar, Container)
├── Home (ProjectList)
│   ├── ProjectCard (MUI Card)
│   └── ProjectForm (MUI Dialog)
├── ProjectDetail
│   ├── ProjectInfo (MUI Card)
│   ├── TaskList (MUI List)
│   ├── TaskForm (MUI TextField + Button)
│   └── TaskItem (MUI ListItem + Checkbox)
└── Common
    ├── Loading (MUI CircularProgress)
    └── ErrorMessage (MUI Alert)
```

#### State Management
- **Context + useReducer** for global state
- **Actions:**
  - FETCH_PROJECTS
  - ADD_PROJECT
  - UPDATE_PROJECT
  - DELETE_PROJECT
  - ADD_TASK
  - TOGGLE_TASK
  - DELETE_TASK
- **Reducer** handles all state transitions

#### API Service Layer

```typescript
// src/services/api.ts
- getProjects()
- getProject(id)
- createProject(data)
- updateProject(id, data)
- deleteProject(id)
- createTask(projectId, data)
- updateTask(id, data)
- deleteTask(id)
```

#### Jest Tests
- Unit tests for reducer logic
- Component tests for all components
- Mock API calls with MSW (Mock Service Worker)
- Test form validation
- Test optimistic updates

---

## 🔐 Phase 3: Authentication & Enhanced UX

**Goal:** Add authentication and implement all bonus features

### Backend - Authentication

**Implementation:**
- Add Devise or JWT-based auth:
  - User model (email, password_digest)
  - Sessions/tokens
- Protect all endpoints except registration/login
- Add user association to projects (user_id)
- Update serializers to include user info

**Auth Endpoints:**

| Method | Route | Description |
|--------|-------|-------------|
| POST | `/api/v1/auth/register` | Sign up |
| POST | `/api/v1/auth/login` | Sign in |
| DELETE | `/api/v1/auth/logout` | Sign out |
| GET | `/api/v1/auth/me` | Current user |

**RSpec Tests:**
- User model specs
- Authentication request specs
- Authorization specs (can't edit other's projects)

### Frontend - Authentication

**Components:**
- Login/Register forms (MUI components)
- Auth context with useReducer
- Protected routes (redirect to login if not authenticated)
- Store JWT token in localStorage
- Add token to all API requests

**Auth UI:**
- Login page (MUI Card + TextField)
- Register page
- User menu in AppBar (MUI Menu)

### Enhanced UX Features

#### ✅ Form Validation
- Client-side validation using MUI + React Hook Form
- Project name required (min 3 chars)
- Task title required (min 1 char)
- Show validation errors (MUI FormHelperText)

#### ✅ Optimistic UI Updates
- Immediately update UI when user makes changes
- Rollback on API error
- Show subtle loading indicators (MUI LinearProgress)

#### ✅ Polish
- Toast notifications using notistack (MUI Snackbar)
- Confirmation dialogs for delete actions (MUI Dialog)
- Loading states with MUI Skeleton components
- Error boundaries
- Empty states with helpful messages
- Responsive design (MUI Grid/Stack)
- Dark mode toggle (MUI ThemeProvider)

### Backend Enhancements
- Pagination for projects (`?page=1&per_page=20`)
- Search/filter (`?search=keyword`)
- Validation error messages
- Database indexes on foreign keys
- Proper HTTP status codes

### Testing
- Add auth tests to both frontend and backend
- Test protected routes
- Test optimistic updates and rollbacks
- Integration tests for auth flows
- Aim for 80%+ code coverage

---

## 📝 Phase 4: Polish, Performance & Documentation

**Goal:** Production-ready application with comprehensive documentation

### Backend
- Database seeds with sample projects/tasks/users
- N+1 query optimization (includes/eager loading)
- API rate limiting (rack-attack)
- Error handling middleware
- Logging improvements
- Database migrations review
- Final RSpec test coverage check

### Frontend
- Code splitting for routes
- Lazy loading components
- Image optimization (if any)
- Bundle size analysis
- Accessibility audit (ARIA labels, keyboard navigation)
- Final Jest test coverage check
- Performance testing (React DevTools Profiler)

### Documentation

#### Backend README
- Tech stack overview
- Prerequisites (Docker, Docker Compose)
- Setup instructions
- Environment variables
- Running tests (`docker compose exec api bundle exec rspec --format progress --fail-fast`)
- API documentation (endpoints, request/response examples)
- Database schema

#### Frontend README
- Tech stack overview
- Setup instructions
- Environment variables
- Running tests (`docker compose exec web npm test`)
- Component documentation
- State management architecture
- Available scripts

#### Root README
- Project overview
- Quick start guide
- Docker Compose usage
- Architecture diagram
- Development workflow
- Testing strategy
- Deployment considerations

### Final Checklist
- [ ] All 8 API endpoints working
- [ ] All CRUD operations functional
- [ ] Authentication working end-to-end
- [ ] Form validation on all forms
- [ ] Optimistic updates implemented
- [ ] Tests passing (backend + frontend)
- [ ] No console errors
- [ ] Responsive design working
- [ ] Error handling robust
- [ ] Documentation complete
- [ ] Code is clean and well-organized
- [ ] Ready for demonstration

---

## ⏱️ Estimated Timeline

| Phase | Description | Estimated Time |
|-------|-------------|----------------|
| Phase 1 | Hello World Application | 2-3 hours |
| Phase 2 | Core Features (Projects + Tasks) | 6-8 hours |
| Phase 3 | Authentication + Enhanced UX | 4-6 hours |
| Phase 4 | Polish + Documentation | 2-3 hours |
| **Total** | | **14-20 hours** |

---

## 🎯 Requirements Checklist

### Core Requirements
- [ ] Rails API-only backend with nested resources
- [ ] React (Hooks) SPA consuming the API
- [ ] PostgreSQL database
- [ ] Docker + Docker Compose setup

### Backend Requirements
- [ ] Project model (id, name, description)
- [ ] Task model (id, title, completed, project_id)
- [ ] All 8 specified endpoints
- [ ] JSON serialization
- [ ] RSpec unit/integration/request tests

### Frontend Requirements
- [ ] List all projects on home screen
- [ ] Create new projects
- [ ] View project details with tasks
- [ ] Add new tasks to projects
- [ ] Toggle task completion (checkbox)
- [ ] Delete tasks
- [ ] React Router for project pages
- [ ] Form validation
- [ ] Optimistic UI updates
- [ ] State management via useReducer
- [ ] Jest unit and component tests

### Bonus Features
- [ ] Basic authentication
- [ ] Material-UI components
- [ ] Dark mode toggle
- [ ] Toast notifications
- [ ] Loading states
- [ ] Error handling
- [ ] Responsive design
- [ ] API versioning (/api/v1)

---

## 🚀 Getting Started

Once implementation begins, use these commands:

### Start all services
```bash
docker compose up
```

### Run backend tests
```bash
docker compose exec api bundle exec rspec --format progress --fail-fast
```

### Run frontend tests
```bash
docker compose exec web npm test
```

### Access the application
- Frontend: http://localhost:5173
- Backend API: http://localhost:3000
- API Health: http://localhost:3000/api/v1/hello

---

**Status:** Ready for implementation 🎉

