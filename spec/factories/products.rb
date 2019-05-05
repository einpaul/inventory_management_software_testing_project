# Read about factories at https://github.com/thoughtbot/factory_girl
require 'support/fixture_helpers'
data = read_fixture_file('product.json')

FactoryGirl.define do
  factory :product do
    name data["factory_product"]["name"]
    quantity data["factory_product"]["quantity"]
    remaining_quantity data["factory_product"]["quantity"]
    code data["factory_product"]["code"]
    description data["factory_product"]["description"]
  end
end
