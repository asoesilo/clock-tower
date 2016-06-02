FactoryGirl.define do
  factory :statement do
    from        { 1.month.ago }
    to          { 1.month.from_now }
    post_date   { 2.months.from_now }

    association :user, factory: :user
  end
end
