# Clear existing data
Task.destroy_all
Project.destroy_all
User.destroy_all

# Create demo users
demo_user = User.create!(
  email: "demo@example.com",
  password: "Password123",
  password_confirmation: "Password123"
)

# Create sample projects for demo user
project1 = demo_user.projects.create!(
  name: "Website Redesign",
  description: "Redesign the company website with modern UI/UX"
)

project2 = demo_user.projects.create!(
  name: "Mobile App",
  description: "Develop iOS and Android mobile applications"
)

project3 = demo_user.projects.create!(
  name: "Marketing Campaign",
  description: "Q1 2026 marketing campaign planning and execution"
)

# Create sample tasks for project 1
project1.tasks.create!([
  { title: "Create wireframes", completed: true },
  { title: "Design homepage mockup", completed: true },
  { title: "Implement responsive layout", completed: false },
  { title: "Add contact form", completed: false }
])

# Create sample tasks for project 2
project2.tasks.create!([
  { title: "Set up React Native project", completed: true },
  { title: "Design app navigation", completed: false },
  { title: "Implement user authentication", completed: false }
])

# Create sample tasks for project 3
project3.tasks.create!([
  { title: "Research target audience", completed: false },
  { title: "Create content calendar", completed: false }
])

puts "✅ Seeded #{Project.count} projects with #{Task.count} tasks for #{User.count} users"
