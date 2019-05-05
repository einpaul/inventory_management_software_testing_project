# Read about factories at https://github.com/thoughtbot/factory_girl
require 'support/fixture_helpers'
data = read_fixture_file('review.json')

FactoryGirl.define do
  factory :review do
    rating data["review_factory_attrs"]["rating"]
    body data["review_factory_attrs"]["body"]
  end
end
