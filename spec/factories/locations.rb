# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :location do
    name          { Faker::Address.city }
    province      { Location::HOLIDAY_CODES.keys.sample }
    tax_percent   { rand(100) }
    tax_name      { Faker::Address.state_abbr }

    association :creator, factory: :user, strategy: :build
    
  end
end
