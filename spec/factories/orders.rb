# Read about factories at https://github.com/thoughtbot/factory_girl
require 'support/fixture_helpers'
data = read_fixture_file('order.json')

FactoryGirl.define do
  factory :order do
    quantity data["order_factory_attributes"]["quantity"]
    status data["order_factory_attributes"]["status"]
    expire_at data["order_factory_attributes"]["expire_at"]
  end
end
