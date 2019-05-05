# Read about factories at https://github.com/thoughtbot/factory_girl
require 'support/fixture_helpers'
data = read_fixture_file('supplier.json')

FactoryGirl.define do
  factory :supplier do
    name data["factory_supplier"]["name"]
    email data["factory_supplier"]["email"]
    phone data["factory_supplier"]["phone"]
    status data["factory_supplier"]["status"]
  end
end
