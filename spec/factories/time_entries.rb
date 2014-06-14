# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :time_entry do
    association             :user
    association             :project
    association             :task
    entry_date              { Date.today }
    duration_in_hours       { rand * 10 }
    comments                { Faker::Lorem.sentence }
  end
end
