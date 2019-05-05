require 'rails_helper'
# frozen_string_literal: true
RSpec.describe ProductsController, type: :controller do

  before do
    @user_data = read_fixture_file('user.json')
    @customer_user = FactoryGirl.create :user,
                                        email: @user_data["customer_user"]["email"],
                                        role: @user_data["customer_user"]["role"]

    @manager_user = FactoryGirl.create :user,
                                        role: @user_data["manager_user"]["role"],
                                        email: @user_data["manager_user"]["email"]
    @catgeory = FactoryGirl.create :category
    @supplier = FactoryGirl.create :supplier
    sign_in(@manager_user, scope: :user)
    @response = "You have requested a page that you do not have access to."
    @product_data = read_fixture_file('product.json')
  end

   describe 'GET #index' do
    it 'populates an array of products' do
      product1 = FactoryGirl.create(:product, category: @catgeory)
      product2 = FactoryGirl.create(:product, category: @catgeory)
      get :index
      expect(assigns(:products).sort).to eq([product1, product2].sort)
    end

    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe'GET #edit' do
    before do
      @product = FactoryGirl.create(:product, category: @catgeory)
    end

    it 'assigns the requested product to @product' do
      get :edit, params: { id: @product }
      expect(assigns(:product)).to eq @product
    end
    it 'renders the :edit template' do
      get :edit, params: { id: @product }
      expect(response).to render_template :edit
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      before do
        @product_factory_attrs =  FactoryGirl.attributes_for(:product, category_id: @catgeory.id)
      end

      it "saves the new product in the database" do
        expect { post :create, params: { product: @product_factory_attrs }}.to change(Product, :count).by(1)
      end

      it 'redirects to manager home' do
        post :create, params: { product: @product_factory_attrs }
        expect(response).to redirect_to root_path
      end

      it 'the created product gets assigned to the category' do
        post :create, params: { product: @product_factory_attrs }
        expect(Product.last.category).to eq @catgeory
      end

      it 'will not allow to create product if user is NOT manager' do
        sign_out(@manager_user)
        sign_in(@customer_user, scope: :user)
        post :create, params: { product: @product_factory_attrs }
        expect(response).to eq @response
      end
    end

    context "with invalid attributes" do
      before do
        @invalid_product_factory_attrs =  FactoryGirl.attributes_for(:product,
                                                                      category: @catgeory,
                                                                      name: @product_data["invalid_product_factory_attrs"]["name"])
      end

      it 'does not save the new product in the database' do
        product_params = { product: @invalid_product_factory_attrs }
        expect { post :create, params: product_params }.to_not change(Product, :count)
      end

      it 're-renders the :new template' do
        post :create, params: { product: @invalid_product_factory_attrs }
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #show' do
    before do
      @product = FactoryGirl.create(:product, category: @catgeory)
    end

    it 'assigns the requested product to @product' do
      get :show, params: { id: @product }
      assert_equal @product, assigns(:product)
    end

    it 'renders the #show view' do
      get :show, params: { id: @product }
      expect(response).to render_template :show
    end

    it 'shows customer reviews only pertaining to the chosen product' do
      review1 = FactoryGirl.create(:review, product: @product, user: @customer_user )
      review2 = FactoryGirl.create(:review, product: @product, user: @customer_user )
      new_product = FactoryGirl.create :product, category: @catgeory
      new_review = FactoryGirl.create(:review, product: new_product, user: @customer_user )
      get :show, params: { id: @product }
      expect(@product.reviews).to eq([review1, review2].sort)
      expect(@product.reviews).to_not eq([new_review].sort)
    end
  end

  describe 'PATCH #update' do
    before do
      @product = FactoryGirl.create :product, category: @catgeory
      @product_attrs = FactoryGirl.attributes_for(:product, category: @catgeory)
    end

   context 'valid attributes' do

    before do
      @product_valid_update_attrs = FactoryGirl.attributes_for(:product,
                                                                name: @product_data["product_valid_update_attrs"]["name"],
                                                                quantity: @product_data["product_valid_update_attrs"]["quantity"],
                                                                category: @catgeory)
    end

     it 'locates the requested @product' do
      patch :update, params: { id: @product, product: @product_attrs }
      expect(assigns(:product)).to eq(@product)
     end

    it 'changes @product\'s attributes' do
      patch :update, params: {
        id: @product,
        product: @product_valid_update_attrs
      }
      @product.reload
      expect(@product.name).to eq(@product_data["product_valid_update_attrs"]["name"])
      expect(@product.quantity).to eq(@product_data["product_valid_update_attrs"]["quantity"])
    end

    it 'redirects to the root path' do
      patch :update, params: { id: @product, product: @product_valid_update_attrs }
      expect(response).to redirect_to root_path
    end

    it 'does not update the product if user is customer' do
      sign_out(@manager_user)
      sign_in(@customer_user, scope: :user)
      patch :update, params: {
        id: @product,
        product: @product_valid_update_attrs
      }
      expect(response).to eq @response
    end
   end

   context 'invalid attributes' do
    before do
      @product_invalid_update_attrs = FactoryGirl.attributes_for(:product,
                                                                  name: @product_data["product_invalid_update_attrs"]["name"],
                                                                  quantity: @product_data["product_invalid_update_attrs"]["quantity"],
                                                                  category: @catgeory)
    end

    it 'locates the requested @product' do
      patch :update, params: { id: @product, product: @product_attrs }
      expect(assigns(:product)).to eq(@product)
    end

    it 'does not change @product\'s attributes' do
      patch :update, params: {
        id: @product,
        product: @product_invalid_update_attrs
      }
      @product.reload
      expect(@product.quantity).to eq(@product_data["factory_product"]["quantity"])
      expect(@product.name).to_not eq(@product_data["product_invalid_update_attrs"]["name"])
    end

    it 're-renders the edit method' do
      patch :update, params: {
          id: @product,
          product: @product_invalid_update_attrs
       }
       expect(response).to render_template :edit
    end
   end
  end
  describe 'DELETE #destroy' do
    before do
      @product = FactoryGirl.create :product, category: @catgeory
    end

    context 'Deleting Product' do
      it 'deletes product if action is by owner' do
        expect { delete :destroy, params: { id: @product } }.to change(Product, :count).by(-1)
      end

      it 'does not allow to delete the product if user is customer' do
        sign_out(@manager_user)
        sign_in(@customer_user, scope: :user)
        delete :destroy, params: { id: @product }
        expect(response).to eq @response
      end
    end
  end
end