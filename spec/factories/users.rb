# frozen_string_literal: true
# Read about factories at https://github.com/thoughtbot/factory_girl

require 'support/fixture_helpers'
data = read_fixture_file('user.json')

FactoryGirl.define do
  factory :user do
    email data["factory_user"]["email"]
    password data["factory_user"]["password"]
    password_confirmation data["factory_user"]["password_confirmation"]
    name data["factory_user"]["name"]
    role data["factory_user"]["role"]
  end
end
