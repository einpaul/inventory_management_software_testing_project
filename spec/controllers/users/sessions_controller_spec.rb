require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  include Devise::Test::ControllerHelpers
   before do
    setup_controller_for_warden
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'User Sign in' do
    context 'Successful login' do
      before do
        @user = FactoryGirl.create(:user)
      end

      it 'should login user' do
        sign_in @user
        warden.authenticated?(:user).should == true
        expect(subject.send(:current_user)).not_to be_nil
        expect(response.status).to eq 200
      end
    end

    context 'Failed login' do
      before do
        @user_session_attrs = FactoryGirl.attributes_for(:user)
      end

      it 'should not login user' do
        params = { user: @user_session_attrs }
        post :create, params: params
        expect(subject.send(:current_user)).to be_nil
      end
    end
  end
end









