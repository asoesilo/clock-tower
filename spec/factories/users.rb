# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    firstname   { Faker::Name.first_name }
    lastname    { Faker::Name.last_name }
    email       { Faker::Internet.safe_email }
    password    { Faker::Internet.password }
  end
  factory :user_invalid_email, class: User do
    firstname   { Faker::Name.first_name }
    lastname    { Faker::Name.last_name }
    email       { Faker::Name.name }
    password    { Faker::Internet.password }
  end
end
