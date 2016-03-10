# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :statement_period do
    from        { [rand(31), 'End of Month', 'Start of Month'].sample }
    to          { [rand(31), 'End of Month', 'Start of Month'].sample }
    draft_days  { rand(31) }
  end
end
