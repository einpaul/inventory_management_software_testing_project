# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :order do
    quantity 200
    status 'true'
    expire_at Faker::Date.between(2.years.ago, Date.today)
    product_id 1
    supplier_id 1
  end
end
