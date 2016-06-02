# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create user admin account if one does not yet exist
ADMIN_FIRSTNAME = "my"
ADMIN_LASTNAME = "admin"
ADMIN_EMAIL = "my@admin.com"
ADMIN_PASSWORD = "my@admin.com"

admin = User.find_by(email: ADMIN_EMAIL)
if admin.nil?
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

Project.delete_all
# Projects
@projects = []
@projects << Project.create!(creator: admin, name: 'Web Immersive')
@projects << Project.create!(creator: admin, name: 'iOS Immersive')
@projects << Project.create!(creator: admin, name: 'Web Fundamentals')

@projects << Project.create!(creator: admin, name: 'Compass')
@projects << Project.create!(creator: admin, name: 'Clocktower')
@projects << Project.create!(creator: admin, name: 'Lighthouse Site')
@projects << Project.create!(creator: admin, name: 'HTML500 Site')
@projects << Project.create!(creator: admin, name: 'HTML500')

Task.delete_all
# Tasks
@tasks = []
@tasks << Task.create!(creator: admin, name: 'TA')
@tasks << Task.create!(creator: admin, name: 'Lecture / Class')
@tasks << Task.create!(creator: admin, name: 'Breakout')
@tasks << Task.create!(creator: admin, name: 'Pod Leading')
@tasks << Task.create!(creator: admin, name: 'Project Mentoring')
@tasks << Task.create!(creator: admin, name: 'Software Development')
@tasks << Task.create!(creator: admin, name: 'Meeting')
@tasks << Task.create!(creator: admin, name: 'Curriculum Development')
@tasks << Task.create!(creator: admin, name: 'Unknown Legacy')
@tasks << Task.create!(creator: admin, name: 'Grading Tests')

User.where(is_admin: false).delete_all
# Worker bees
@users = []
20.times do
  @users << User.create!(
    firstname:   Faker::Name.first_name,
    lastname:     Faker::Name.last_name,
    email:        Faker::Internet.safe_email,
    password:     Faker::Internet.password,
    active:       true,
    is_admin:     false,
    hourly:       true,
    rate:         [20,25,30,35].sample(),
    secondary_rate: [30,35,40].sample(),
    holiday_rate_multiplier: 1,
    password_reset_required: false,
    company_name: Faker::Company.name,
    tax_number:   Faker::Number.number(10),
    creator: admin
  )
end

TimeEntry.delete_all
# Makes some time entries
start_date = Date.today.weeks_ago(12)

begin
  @users.sample(10).each do |u|
    TimeEntry.create!(
      user: u,
      project: @projects.sample,
      task: @tasks.sample,
      entry_date: start_date,
      duration_in_hours: [0.5,1,2,3,4].sample
    )
  end
  start_date = start_date.next
end while start_date <= Date.today

StatementPeriod.destroy_all
# statement periods
StatementPeriod.create!(from: 'Start of Month', to: 15, draft_days: 3)
StatementPeriod.create!(from: 16, to: 'End of Month', draft_days: 3)

# Destroy Statements
Statement.destroy_all
