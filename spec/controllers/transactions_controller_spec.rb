require 'rails_helper'
# frozen_string_literal: true
RSpec.describe TransactionsController, type: :controller do
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
    @supplier = FactoryGirl.create :supplier
    sign_in(@manager_user, scope: :user)
    @response = "You have requested a page that you do not have access to."
    @supplier_data = read_fixture_file('supplier.json')
    @transaction_data = read_fixture_file('transaction.json')
  end

  describe "POST #create" do
    context "with valid attributes" do
      before do
        @transaction_factory_attributes = FactoryGirl.attributes_for(:transaction, supplier_id: @supplier.id,
                                                                               product_id: @product.id)
      end

      it "saves the new transaction in the database" do
        expect { post :create, params: { transaction: @transaction_factory_attributes }}.to change(Transaction, :count).by(1)
      end

      it 'redirects to manager/sales_person home' do
        post :create, params: { transaction: @transaction_factory_attributes }
        expect(flash[:notice]).to match(/Transaction was successfully created.*/)
        expect(response).to redirect_to transactions_path
      end

      it 'will not allow to create transaction if user is customer' do
        sign_out(@manager_user)
        sign_in(@customer_user, scope: :user)
        post :create, params: { transaction: @transaction_factory_attributes }
        expect(response).to eq @response
      end

      it 'the created transaction gets assigned to the chosen product' do
        post :create, params: { transaction: @transaction_factory_attributes }
        expect(Transaction.last.product).to eq @product
      end

      it 'the created transaction gets assigned to the chosen supplier' do
        post :create, params: { transaction: @transaction_factory_attributes }
        expect(Transaction.last.supplier).to eq @supplier
      end

      it 'decrements the product quantity once transaction is saved' do
        post :create, params: { transaction: @transaction_factory_attributes }
        expect(Transaction.last.product.remaining_quantity).to eq (@product.remaining_quantity - Transaction.last.quantity.to_i)
      end
    end

    context "with invalid attributes" do
      before do
        @invalid_transaction_factory_attributes = FactoryGirl.attributes_for(:transaction,
                                                                      supplier_id: @supplier.id,
                                                                      product_id: @product.id,
                                                                      quantity: @transaction_data["invalid_transaction_factory_attributes"]["quantity"])
      end

      it 'does not save the new transaction in the database' do
        transaction_params = { transaction: @invalid_transaction_factory_attributes }
        expect { post :create, params: transaction_params }.to_not change(Transaction, :count)
      end

      it 're-renders the :new template' do
        post :create, params: { transaction: @invalid_transaction_factory_attributes }
        expect(response).to render_template :new
      end
    end

    context 'supplier status' do
       before do
       @inactive_supplier = FactoryGirl.create :supplier
        @inactive_supplier.update_attributes(status: @supplier_data["inactive_supplier"]["status"])
        @transaction_supplier_status_attrs = { transaction: FactoryGirl.attributes_for(:transaction,
                                                                                      product: @product,
                                                                                      supplier: @inactive_supplier) }
      end

      it 'does not create transaction if supplier is NOT active' do
         expect { post :create, params: @transaction_supplier_status_attrs }.to_not change(Transaction, :count)
      end

      it 'redirects to new template with error message if supplier is NOT active' do
         post :create, params: @transaction_supplier_status_attrs
         expect(response).to render_template :new
         expect(flash[:alert]).to match(/Transaction creation was unsucessfull.*/)
      end
    end
  end

  describe 'GET #index' do
    it 'populates an array of transactions' do
      transaction1 = FactoryGirl.create(:transaction, product: @product, supplier: @supplier)
      transaction2 = FactoryGirl.create(:transaction, product: @product,
                                            supplier: @supplier
                                            )
      get :index
      expect(assigns(:transactions).sort).to eq([transaction1, transaction2].sort)
    end

    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe'GET #edit' do
    before do
      @transaction = FactoryGirl.create(:transaction, product: @product, supplier: @supplier)
    end

    it 'assigns the requested transaction to @transaction' do
      get :edit, params: { id: @transaction }
      expect(assigns(:transaction)).to eq @transaction
    end
    it 'renders the :edit template' do
      get :edit, params: { id: @transaction }
      expect(response).to render_template :edit
    end
  end

  describe 'PATCH #update' do

    before do
      @transaction = FactoryGirl.create :transaction, product: @product, supplier: @supplier
    end

   context 'valid attributes' do
      before do
        @transaction_valid_update_attrs = FactoryGirl.attributes_for(:transaction,
                                                                      product: @product,
                                                                      supplier: @supplier)
      end

     it 'locates the requested @transaction' do
      patch :update, params: { id: @transaction, transaction: @transaction_valid_update_attrs }
      expect(assigns(:transaction)).to eq(@transaction)
     end

    it 'changes @transaction\'s attributes' do
      patch :update, params: {
        id: @transaction,
        transaction: @transaction_valid_update_attrs
      }
      @transaction.reload
      expect(@transaction.quantity).to eq(@transaction_data["transaction_factory_attrs"]["quantity"])
      expect(@transaction.transaction_id).to eq(@transaction_data["transaction_factory_attrs"]["transaction_id"])
    end

    it 'redirects to the transaction list' do
      patch :update, params: { id: @transaction, transaction: @transaction_valid_update_attrs }
      expect(response).to redirect_to transactions_path
    end

    it 'does not update the transaction if user is manager' do
      sign_out(@customer_user)
      sign_in(@manager_user, scope: :user)
      patch :update, params: {
        id: @transaction,
        transaction: @transaction_valid_update_attrs
      }
      expect(response).to eq @response
    end
   end

   context 'invalid attributes' do
    before do
        @transaction_invalid_update_attrs = FactoryGirl.attributes_for(:transaction,
                                                                        quantity: @transaction_data["invalid_transaction_factory_attributes"]["quantity"],
                                                                        product: @product,
                                                                        supplier: @supplier)
      end
    it 'locates the requested @transaction' do
      patch :update, params: { id: @transaction, transaction:  @transaction_invalid_update_attrs }
      expect(assigns(:transaction)).to eq(@transaction)
    end

    it 'does not change @transaction\'s attributes' do
      patch :update, params: {
        id: @transaction,
        transaction: @transaction_invalid_update_attrs
      }
      @transaction.reload
      expect(@transaction.quantity).to eq(@transaction_data["transaction_factory_attrs"]["quantity"])
      expect(@transaction.transaction_id).to_not eq(@transaction_data["invalid_transaction_factory_attributes"]["transaction_id"])
    end

    it 're-renders the edit method' do
      patch :update, params: {
          id: @transaction,
          transaction: @transaction_invalid_update_attrs
       }
       expect(response).to render_template :edit
    end
   end
  end

  describe 'DELETE #destroy' do
    before do
      @transaction = FactoryGirl.create :transaction, product: @product, supplier: @supplier
    end

    context 'Deleting transaction' do
      it 'deletes transaction' do
        expect { delete :destroy, params: { id: @transaction } }.to change(Transaction, :count).by(-1)
      end

      it 'does not allow to delete the transaction if user is NOT manager' do
        sign_out(@manager_user)
        sign_in(@customer_user, scope: :user )
        delete :destroy, params: { id: @transaction }
        expect(response).to eq @response
      end

      it 'redirects to the trasanctions index' do
        delete :destroy, params: { id: @transaction }
        expect(response).to redirect_to transactions_path
        expect(flash[:notice]).to match(/Transaction was successfully destroyed.*/)
      end
    end
  end

end