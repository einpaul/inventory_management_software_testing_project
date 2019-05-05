require 'rails_helper'
# frozen_string_literal: true
RSpec.describe SuppliersController, type: :controller do
  before do
    @user_data = read_fixture_file('user.json')
    @customer_user = FactoryGirl.create :user,
                                        email: @user_data["customer_user"]["email"],
                                        role: @user_data["customer_user"]["role"]

    @manager_user = FactoryGirl.create :user,
                                        role: @user_data["manager_user"]["role"],
                                        email: @user_data["manager_user"]["email"]
    @catgeory = FactoryGirl.create :category
    @product = FactoryGirl.create :product, category: @catgeory
    sign_in(@manager_user, scope: :user)
    @response = "You have requested a page that you do not have access to."
    @supplier_factory_attrs = FactoryGirl.attributes_for(:supplier)
    @supplier_data = read_fixture_file('supplier.json')
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new supplier in the database" do
        expect { post :create, params: { supplier: @supplier_factory_attrs }}.to change(Supplier, :count).by(1)
      end

      it 'redirects to manager home' do
        post :create, params: { supplier: @supplier_factory_attrs }
        expect(response).to redirect_to root_path
      end

      it 'will not allow to create supplier if user is customer' do
        sign_out(@manager_user)
        sign_in(@customer_user, scope: :user)
        post :create, params: { supplier: @supplier_factory_attrs }
        expect(response).to eq @response
      end
    end

    context "with invalid attributes" do
      before do
        @invalid_factory_attributes = FactoryGirl.attributes_for(:supplier,
                                                                  name: @supplier_data["invalid_factory_attrs"]["name"])
      end

      it 'does not save the new supplier in the database' do
        expect { post :create, params: { supplier: @invalid_factory_attributes }  }.to_not change(Supplier, :count)
      end

      it 're-renders the :new template' do
        post :create, params: { supplier: @invalid_factory_attributes }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before do
      @supplier = FactoryGirl.create :supplier
    end

   context 'valid attributes' do

    before do
      @valid_update_factory_attributes = FactoryGirl.attributes_for(:supplier,
                                                                    name: @supplier_data["valid_update_factory_attributes"]["name"],
                                                                    phone: @supplier_data["valid_update_factory_attributes"]["phone"])
    end

     it 'locates the requested @supplier' do
      patch :update, params: { id: @supplier, supplier: @supplier_factory_attrs }
      expect(assigns(:supplier)).to eq(@supplier)
     end

    it 'changes @supplier\'s attributes' do
      patch :update, params: {
        id: @supplier,
        supplier: @valid_update_factory_attributes
      }
      @supplier.reload
      expect(@supplier.name).to eq(@supplier_data["valid_update_factory_attributes"]["name"])
      expect(@supplier.phone).to eq(@supplier_data["valid_update_factory_attributes"]["phone"])
    end

    it 'redirects to the updated supplier' do
      patch :update, params: { id: @supplier, supplier: @supplier_factory_attrs }
      expect(response).to redirect_to root_path
    end

    it 'does not update the supplier if user is customer' do
      sign_out(@manager_user)
      sign_in(@customer_user, scope: :user)
      patch :update, params: {
        id: @supplier,
        supplier: @valid_update_factory_attributes
      }
      expect(response).to eq @response
    end
   end

   context 'invalid attributes' do
    before do
      @invalid_update_factory_attributes = FactoryGirl.attributes_for(:supplier,
                                                                      name: @supplier_data["invalid_update_factory_attributes"]["name"],
                                                                      phone: @supplier_data["invalid_update_factory_attributes"]["phone"])
    end
    it 'locates the requested @supplier' do
      patch :update, params: { id: @supplier, supplier: @supplier_factory_attrs }
      expect(assigns(:supplier)).to eq(@supplier)
    end

    it 'does not change @supplier\'s attributes' do
      patch :update, params: {
        id: @supplier,
        supplier: @invalid_update_factory_attributes
      }
      @supplier.reload
      expect(@supplier.name).to eq(@supplier_data["factory_supplier"]["name"])
      expect(@supplier.phone).to_not eq(@supplier_data["invalid_update_factory_attributes"]["phone"])
    end

    it 're-renders the edit method' do
      patch :update, params: {
          id: @supplier,
          supplier: @invalid_update_factory_attributes
       }
       expect(response).to render_template :edit
    end
   end
  end

  describe'GET #edit' do
    before do
      @supplier = FactoryGirl.create(:supplier)
    end

    it 'assigns the requested supplier to @supplier' do
      get :edit, params: { id: @supplier }
      expect(assigns(:supplier)).to eq @supplier
    end
    it 'renders the :edit template' do
      get :edit, params: { id: @supplier }
      expect(response).to render_template :edit
    end
  end

  describe 'GET #show' do
    before do
      @supplier = FactoryGirl.create(:supplier)
    end

    it 'assigns the requested supplier to @supplier' do
      get :show, params: { id: @supplier }
      assert_equal @supplier, assigns(:supplier)
    end

    it 'renders the #show view' do
      get :show, params: { id: @supplier }
      expect(response).to render_template :show
    end

    it 'shows customer reviews only pertaining to the chosen supplier' do
      review1 = FactoryGirl.create(:review, supplier: @supplier, user: @customer_user )
      review2 = FactoryGirl.create(:review, supplier: @supplier, user: @customer_user )
      new_supplier = FactoryGirl.create :supplier
      new_review = FactoryGirl.create(:review, supplier: new_supplier, user: @customer_user )
      get :show, params: { id: @supplier }
      expect(@supplier.reviews).to eq([review1, review2].sort)
      expect(@supplier.reviews).to_not eq([new_review].sort)
    end
  end

  describe 'PATCH /suppliers/:id/#action' do
    before do
      @supplier = FactoryGirl.create(:supplier)
    end

    context 'manager user' do
      it 'marks the supplier as disabled' do
        patch :disable, params: { id: @supplier }
        expect(@supplier.reload.status).to eq 'disabled'
      end

      it 'marks the supplier as revoked' do
        patch :revoke, params: { id: @supplier }
        expect(@supplier.reload.status).to eq 'revoked'
      end

      it 'marks the supplier as active' do
        patch :activate, params: { id: @supplier }
        expect(@supplier.reload.status).to eq 'active'
      end
    end

    context 'customer user' do
      it 'does not perform any action if user is customer' do
        sign_out(@manager_user)
        sign_in(@customer_user, scope: :user)
        patch :disable, params: { id: @supplier }
        expect(response).to eq @response
      end
    end
  end
end








