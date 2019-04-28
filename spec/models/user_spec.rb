# frozen_string_literal: true
require 'rails_helper'

RSpec.describe User, type: :model do
  # before do
  #   @user = FactoryGirl.create(:user)
  # end

  it 'has a valid factory' do
    expect(FactoryGirl.build(:user).save).to be_truthy
  end

  it 'adds an user to database with valid fields' do
    expect { FactoryGirl.create(:user).save }.to change(User, :count).by(1)
  end

  it 'is invalid without an email' do
    user = FactoryGirl.build(:user, email: nil)
    expect(user).to_not be_valid
  end

  it 'is invalid without a unique email' do
    user = FactoryGirl.create(:user, email: 'abc123@gmail.com')
    expect(FactoryGirl.build(:user, email: 'abc123@gmail.com')).to_not be_valid
  end
end






