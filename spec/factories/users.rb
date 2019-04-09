# frozen_string_literal: true
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email Faker::Internet.email
    password 'foobar123'
    password_confirmation 'foobar123'
    name Faker::Name.name
  end
end
