# Clear existing data
Task.destroy_all
Project.destroy_all

# Create sample projects
project1 = Project.create!(
  name: "Website Redesign",
  description: "Redesign the company website with modern UI/UX"
)

project2 = Project.create!(
  name: "Mobile App",
  description: "Develop iOS and Android mobile applications"
)

project3 = Project.create!(
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

puts "✅ Seeded #{Project.count} projects with #{Task.count} tasks"
