# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project do
    name    { Faker::Lorem.word }
    association :creator, factory: :user, strategy: :build

    factory :project_without_name do
      name nil
    end
  end
end
