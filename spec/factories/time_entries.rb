# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :time_entry do
    association             :user, factory: :user
    association             :project, factory: :project
    association             :task, factory: :task
    entry_date              { Date.today }
    duration_in_hours       { rand * 10 }
    comments                { Faker::Lorem.sentence }
    rate                    { rand 50 }
    apply_rate              { [true, false].sample }
    is_holiday              { Date.today.holiday? }
    holiday_rate_multiplier { rand * 3.0 }
    holiday_code            { :ca_bc }
    has_tax                 { [true, false].sample }
    tax_desc                { Faker::Superhero.power }
    tax_percent             { rand * 10.0 }
  end
end
