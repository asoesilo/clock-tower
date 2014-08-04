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
ADMIN_PASSWORD = "admin"

if User.find_by(email: ADMIN_EMAIL).nil?
  User.create(firstname: ADMIN_FIRSTNAME, lastname: ADMIN_LASTNAME, email: ADMIN_EMAIL, password: ADMIN_PASSWORD, is_admin: true)
end