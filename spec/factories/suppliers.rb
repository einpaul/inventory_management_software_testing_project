# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :supplier do
    name Faker::Company.name
    email Faker::Internet.email
    phone Faker::Number.number(10)
    status 'active'
  end
end
