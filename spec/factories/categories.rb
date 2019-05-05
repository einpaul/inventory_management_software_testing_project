# Read about factories at https://github.com/thoughtbot/factory_girl
require 'support/fixture_helpers'
data = read_fixture_file('category.json')

FactoryGirl.define do
  factory :category do
    name data["name"]
  end
end
