# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project do
    name    { "#{Faker::Lorem.word}#{Faker::Lorem.word}#{Faker::Lorem.word}" }
    association :creator, factory: :user

    factory :project_without_name do
      name nil
    end
  end
end
