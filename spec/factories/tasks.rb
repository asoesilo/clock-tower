# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task do
    name    { Faker::Lorem.sentence }
    association :creator, factory: :user

    factory :task_without_name do
      name nil
    end
  end
end
