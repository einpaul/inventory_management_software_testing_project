require 'rails_helper'
# frozen_string_literal: true
RSpec.describe SuppliersController, type: :controller do
  before do
    @customer_user = FactoryGirl.create :user, role: 'customer'
    @manager_user = FactoryGirl.create :user, role: 'manager', email: 'manager123@gmail.com'
    @catgeory = FactoryGirl.create :category
    @product = FactoryGirl.create :product, category: @catgeory
    @supplier = FactoryGirl.create :supplier
    sign_in(@manager_user, scope: :user)
    @response = "You have requested a page that you do not have access to."
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new supplier in the database" do
        expect { post :create, params: { supplier: FactoryGirl.attributes_for(:supplier) }}.to change(Supplier, :count).by(1)
      end

      it 'redirects to manager home' do
        post :create, params: { supplier: FactoryGirl.attributes_for(:supplier) }
        expect(response).to redirect_to root_path
      end

      it 'will not allow to create supplier if user is customer' do
        sign_out(@manager_user)
        sign_in(@customer_user, scope: :user)
        post :create, params: { supplier: FactoryGirl.attributes_for(:supplier) }
        expect(response).to eq @response
      end
    end

    context "with invalid attributes" do
      it 'does not save the new supplier in the database' do
        supplier_params = { supplier: FactoryGirl.attributes_for(:supplier, name: nil) }
        expect { post :create, params: supplier_params }.to_not change(Supplier, :count)
      end

      it 're-renders the :new template' do
        post :create, params: { supplier: FactoryGirl.attributes_for(:supplier, name: nil) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before do
      @supplier = FactoryGirl.create :supplier
    end
   context 'valid attributes' do
     it 'locates the requested @supplier' do
      patch :update, params: { id: @supplier, supplier: FactoryGirl.attributes_for(:supplier) }
      expect(assigns(:supplier)).to eq(@supplier)
     end

    it 'changes @supplier\'s attributes' do
      patch :update, params: {
        id: @supplier,
        supplier: FactoryGirl.attributes_for(:supplier, name: 'Colgate', phone: '897987564')
      }
      @supplier.reload
      expect(@supplier.name).to eq('Colgate')
      expect(@supplier.phone).to eq('897987564')
    end

    it 'redirects to the updated supplier' do
      patch :update, params: { id: @supplier, supplier: FactoryGirl.attributes_for(:supplier) }
      expect(response).to redirect_to root_path
    end

    it 'does not update the supplier if user is customer' do
      sign_out(@manager_user)
      sign_in(@customer_user, scope: :user)
      patch :update, params: {
        id: @supplier,
        review: FactoryGirl.attributes_for(:supplier, name: 'Colgate', phone: '897987564')
      }
      expect(response).to eq @response
    end
   end

   context 'invalid attributes' do
    it 'locates the requested @supplier' do
      patch :update, params: { id: @supplier, supplier: FactoryGirl.attributes_for(:supplier) }
      expect(assigns(:supplier)).to eq(@supplier)
    end

    it 'does not change @supplier\'s attributes' do
      patch :update, params: {
        id: @supplier,
        supplier: FactoryGirl.attributes_for(:supplier, name: nil, phone: '897987564')
      }
      @supplier.reload
      expect(@supplier.name).to eq('Apple')
      expect(@supplier.phone).to_not eq('897987564')
    end

    it 're-renders the edit method' do
      patch :update, params: {
          id: @supplier,
          supplier: FactoryGirl.attributes_for(:supplier, name: nil, phone: '897987564')
       }
       expect(response).to render_template :edit
    end
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








