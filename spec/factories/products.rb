# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :product do
    name 'Macbook'
    quantity 200
    remaining_quantity 200
    code Faker::Code.asin
    description 'Very Useful product'
  end
end
