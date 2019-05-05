# Read about factories at https://github.com/thoughtbot/factory_girl
require 'support/fixture_helpers'
data = read_fixture_file('transaction.json')

FactoryGirl.define do
  factory :transaction do
    quantity data["transaction_factory_attrs"]["quantity"]
    transaction_id data["transaction_factory_attrs"]["transaction_id"]
  end
end
