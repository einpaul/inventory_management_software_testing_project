# # frozen_string_literal: true
# require 'rails_helper'

# RSpec.describe Order, type: :model do
#   # before do
#   #   @user = FactoryGirl.create(:user)
#   # end

#   it 'has a valid factory' do
#     expect(FactoryGirl.build(:order).save).to be_truthy
#   end

#   it 'adds an user to database with valid fields' do
#     expect { FactoryGirl.create(:order).save }.to change(Order, :count).by(1)
#   end

#   it 'is invalid without reference to a product' do
#     user = FactoryGirl.build(:user, email: nil)
#     expect(user).to_not be_valid
#   end

#   it 'is invalid without reference to a supplier' do
#     user = FactoryGirl.build(:user, email: nil)
#     expect(user).to_not be_valid
#   end

#   describe 'ActiveModel validations' do
#     it { should define_enum_for(:role).with(%w(customer manager sales_person)) }
#   end

#   describe 'ActiveModel associations' do
#     it { should have_many(:reviews) }
#     it { should validate_presence_of(:email) }
#   end

#   describe 'before create' do
#     it 'should set role to customer if user signs up' do
#       user = FactoryGirl.create(:user)
#       expect(user.role).to eq('customer')
#     end
#   end
# end


# expect(val.is_done?).to be_boolean




