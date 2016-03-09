# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    firstname    { Faker::Name.first_name }
    lastname     { Faker::Name.last_name }
    email        { Faker::Internet.safe_email }
    password     { Faker::Internet.password }
    active       true
    is_admin     false
    hourly       false
    rate         0.0
    secondary_rate 0.0
    holiday_rate_multiplier 1
    password_reset_required false
    company_name { Faker::Company.name }
    tax_number   { Faker::Number.number(10) }
    after(:build) { |user|
      allow(user).to receive(:send_email_invite)
    }
    trait :admin do
      is_admin true
    end

    trait :invalid_email do
      email { Faker::Name.name}
    end

    factory :user_admin, traits: [:admin]
    factory :user_invalid_email, traits: [:invalid_email]
  end

end
