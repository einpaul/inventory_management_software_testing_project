require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  include Devise::Test::ControllerHelpers
   before do
    # initial_test_setup
    setup_controller_for_warden
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  context 'register a user' do
    let(:add_user) { post :create, user: FactoryGirl.attributes_for(:user) }

    it { expect { add_user }.to change(User, :count).by(1) }
  end
end