FactoryGirl.define do
  factory :statement do
    from        { 1.month.ago }
    to          { 1.month.from_now }
    subtotal    { rand(1000) }
    tax_amount  { rand(100) }
    total       { rand(1100) }
    hours       { rand(100) }

    association :user, factory: :user
  end
end
