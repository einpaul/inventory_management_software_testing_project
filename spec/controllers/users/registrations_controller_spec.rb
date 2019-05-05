require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  include Devise::Test::ControllerHelpers
   before do
    setup_controller_for_warden
    request.env['devise.mapping'] = Devise.mappings[:user]
    @user_registration_attrs = FactoryGirl.attributes_for(:user)
  end

  context 'register a user' do
    let(:add_user) { post :create, params: { user: @user_registration_attrs } }
    it { expect { add_user }.to change(User, :count).by(1) }
  end
end