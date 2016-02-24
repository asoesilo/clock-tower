# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create user admin account if one does not yet exist

User.delete_all
Project.delete_all
Task.delete_all
TimeEntry.delete_all

ADMIN_FIRSTNAME = "my"
ADMIN_LASTNAME = "admin"
ADMIN_EMAIL = "my@admin.com"
ADMIN_PASSWORD = "my@admin.com"

if admin = User.find_by(email: ADMIN_EMAIL).nil?
  creator = User.new

  admin = User.create!(
    firstname: ADMIN_FIRSTNAME,
    lastname: ADMIN_LASTNAME,
    email: ADMIN_EMAIL,
    password: ADMIN_PASSWORD,
    is_admin: true,
    active: true,
    creator: creator
  )
end

# Projects
Project.create! creator: admin, name: 'Web Immersive'
Project.create! creator: admin, name: 'iOS Immersive'
Project.create! creator: admin, name: 'Web Fundamentals'

Project.create! creator: admin, name: 'Compass'
Project.create! creator: admin, name: 'Clocktower'
Project.create! creator: admin, name: 'Lighthouse Site'
Project.create! creator: admin, name: 'HTML500 Site'
Project.create! creator: admin, name: 'HTML500'

# Tasks

Task.create! creator: admin, name: 'TA'
Task.create! creator: admin, name: 'Lecture / Class'
Task.create! creator: admin, name: 'Breakout'
Task.create! creator: admin, name: 'Pod Leading'
Task.create! creator: admin, name: 'Project Mentoring'
Task.create! creator: admin, name: 'Software Development'
Task.create! creator: admin, name: 'Meeting'
Task.create! creator: admin, name: 'Curriculum Development'
Task.create! creator: admin, name: 'Unknown Legacy'
Task.create! creator: admin, name: 'Grading Tests'
