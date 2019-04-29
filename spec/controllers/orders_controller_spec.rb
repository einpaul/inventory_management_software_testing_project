require 'rails_helper'
# frozen_string_literal: true
RSpec.describe OrdersController, type: :controller do

  before do
    @customer_user = FactoryGirl.create :user, role: 'customer'
    @manager_user = FactoryGirl.create :user, role: 'manager', email: 'manager123@gmail.com'
    @catgeory = FactoryGirl.create :category
    @product = FactoryGirl.create :product, category: @catgeory
    @supplier = FactoryGirl.create :supplier
    sign_in(@manager_user, scope: :user)
    @response = "You have requested a page that you do not have access to."
  end

  describe 'GET #index' do
    it 'populates an array of orders' do
      order1 = FactoryGirl.create(:order, product: @product, supplier: @supplier)
      order2 = FactoryGirl.create(:order, supplier: @supplier,
                                          product: @product
                                        )
      get :index
      expect(assigns(:orders).sort).to eq([order1, order2].sort)
    end

    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
    end
  end

   describe "POST #create" do
    context "with valid attributes" do

      before do
        @order_factory_attributes = FactoryGirl.attributes_for(:order, product_id: @product.id,
                                                                          supplier_id: @supplier.id)
      end
      it "saves the new Order in the database" do
        expect { post :create, params: { order: @order_factory_attributes }}.to change(Order, :count).by(1)

      end

      it 'redirects to Manager home' do
        post :create, params: { order: @order_factory_attributes }
        expect(response).to redirect_to root_path
      end

      it 'the created order gets assigned to the chosen product' do
        post :create, params: { order: @order_factory_attributes }

        expect(Order.last.product).to eq @product
      end

      it 'the created order gets assigned to the chosen supplier' do
        post :create, params: { order: @order_factory_attributes }
        expect(Order.last.supplier).to eq @supplier
      end

      it 'will not allow to create order if user is customer' do
        sign_out(@manager_user)
        sign_in(@customer_user, scope: :user)
        post :create, params: { order: @order_factory_attributes }
        expect(response).to eq @response
      end

      it 'increments the product quantity once order is saved' do
        post :create, params: { order: @order_factory_attributes }
        expect(Order.last.product.remaining_quantity).to eq (@product.quantity + Order.last.quantity.to_i)
      end
    end

    context "with invalid attributes" do
       before do
        @invalid_order_factory_attributes = FactoryGirl.attributes_for(:order, quantity: nil, product_id: @product.id,
                                                                          supplier_id: @supplier.id )
      end
      it 'does not save the new order in the database' do
        order_params = { order: @invalid_order_factory_attributes }
        expect { post :create, params: order_params }.to_not change(Order, :count)
      end

      it 're-renders the :new template' do
        post :create, params: { order: @invalid_order_factory_attributes }
        expect(response).to render_template :new
      end
    end

    context 'supplier status' do
      before do
        @inactive_supplier = FactoryGirl.create :supplier, status: 'revoked'
        @invalid_supplier_order_params = { order: FactoryGirl.attributes_for(:order, quantity: nil, product_id: @product.id,
                                                                          supplier_id: @inactive_supplier.id) }
      end

      it 'does not create order if supplier is NOT active' do
         expect { post :create, params: @invalid_supplier_order_params }.to_not change(Order, :count)
      end

      it 'redirects to new template with error message if supplier is NOT active' do
         post :create, params: @invalid_supplier_order_params
         expect(response).to render_template :new
         expect(flash[:alert]).to match(/Order creation was unsucessfull.*/)
      end
    end
  end


  describe 'DELETE #destroy' do
    before do
      @order = FactoryGirl.create :order, product: @product, supplier: @supplier
    end

    context 'Deleting order' do
      it 'deletes order' do
        expect { delete :destroy, params: { id: @order } }.to change(Order, :count).by(-1)
      end

      it 'does not allow to delete the order if user is NOT manager' do
        sign_out(@manager_user)
        sign_in(@customer_user, scope: :user )
        delete :destroy, params: { id: @order }
        expect(response).to eq @response
      end

      # it 'decrements the quantity of order from products' do
      #   delete :destroy, params: { id: @order }
      #   @order.reload
      #   expect(@order.product.remaining_quantity).to eq (@product.quantity - @order.quantity.to_i)
      # end

      it 'redirects to orders list with error message' do
         delete :destroy, params: { id: @order }
         expect(response).to redirect_to orders_path
         expect(flash[:notice]).to match(/Order was successfully destroyed.*/)
      end
    end
  end

  describe 'GET #return' do
    before do
      @order = FactoryGirl.create :order, product: @product, supplier: @supplier
    end

    context 'Returning order' do

      it 'marks the particular order status as false' do
        get :return, params: { id: @order }
        @order.reload
        expect(@order.status).to eq false
        expect(flash[:notice]).to match(/Product returned back to supplier.*/)
      end

      it 'decrements the quantity from the respective product' do
        get :return, params: { id: @order }
        @order.reload
        expect(@order.product.remaining_quantity).to eq (@product.quantity - @order.quantity.to_i)
      end

      it 'does not allow to return the order if user is NOT manager' do
        sign_out(@manager_user)
        sign_in(@customer_user, scope: :user )
        get :return, params: { id: @order }
        expect(response).to eq @response
      end
    end
  end
end










