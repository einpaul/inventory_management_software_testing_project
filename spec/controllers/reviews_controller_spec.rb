require 'rails_helper'
# frozen_string_literal: true
RSpec.describe ReviewsController, type: :controller do

  before do
    @customer_user = FactoryGirl.create :user, role: 'customer'
    @manager_user = FactoryGirl.create :user, role: 'manager', email: 'manager123@gmail.com'
    @catgeory = FactoryGirl.create :category
    @product = FactoryGirl.create :product, category: @catgeory
    @supplier = FactoryGirl.create :supplier
    sign_in(@customer_user, scope: :user)
    @response = "You have requested a page that you do not have access to."
  end

  describe 'GET #index' do
    it 'populates an array of reviews' do
      review1 = FactoryGirl.create(:review, product: @product, user: @customer_user)
      review2 = FactoryGirl.create(:review, supplier: @supplier,
                                            user: @customer_user
                                            )
      get :index
      expect(assigns(:reviews).sort).to eq([review1, review2].sort)
    end

    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new review in the database" do
        expect { post :create, params: { review: FactoryGirl.attributes_for(:review) }}.to change(Review, :count).by(1)
      end

      it 'redirects to customer home' do
        post :create, params: { review: FactoryGirl.attributes_for(:review) }
        expect(response).to redirect_to root_path
      end

      it 'the created review gets assigned to the currently logged in user' do
        post :create, params: { review: FactoryGirl.attributes_for(:review) }
        expect(Review.last.user).to eq @customer_user
      end

      it 'will not allow to create review if user is manager or salesperson' do
        sign_out(@customer_user)
        sign_in(@manager_user, scope: :user)
        post :create, params: { review: FactoryGirl.attributes_for(:review) }
        expect(response).to eq @response
      end
    end

    context "with invalid attributes" do
      it 'does not save the new review in the database' do
        review_params = { review: FactoryGirl.attributes_for(:review, rating: nil) }
        expect { post :create, params: review_params }.to_not change(Review, :count)
      end

      it 're-renders the :new template' do
        post :create, params: { review: FactoryGirl.attributes_for(:review, rating: nil) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before do
      @review = FactoryGirl.create :review, user: @customer_user
    end
   context 'valid attributes' do
     it 'locates the requested @review' do
      patch :update, params: { id: @review, review: FactoryGirl.attributes_for(:review) }
      expect(assigns(:review)).to eq(@review)
     end

    it 'changes @review\'s attributes' do
      patch :update, params: {
        id: @review,
        review: FactoryGirl.attributes_for(:review, rating: 2, body: 'maddness')
      }
      @review.reload
      expect(@review.rating).to eq(2)
      expect(@review.body).to eq('maddness')
    end

    it 'redirects to the updated review' do
      patch :update, params: { id: @review, review: FactoryGirl.attributes_for(:review) }
      expect(response).to redirect_to reviews_path
    end

    it 'does not update the review if user is manager' do
      sign_out(@customer_user)
      sign_in(@manager_user, scope: :user)
      patch :update, params: {
        id: @review,
        review: FactoryGirl.attributes_for(:review, rating: 2, body: 'maddness')
      }
      expect(response).to eq @response
    end
   end

   context 'invalid attributes' do
    it 'locates the requested @review' do
      patch :update, params: { id: @review, review: FactoryGirl.attributes_for(:review) }
      expect(assigns(:review)).to eq(@review)
    end

    it 'does not change @review\'s attributes' do
      patch :update, params: {
        id: @review,
        review: FactoryGirl.attributes_for(:review, rating: nil, body: 'Super!')
      }
      @review.reload
      expect(@review.rating).to eq(5)
      expect(@review.body).to_not eq('Super!')
    end

    it 're-renders the edit method' do
      patch :update, params: {
          id: @review,
          review: FactoryGirl.attributes_for(:review, rating: nil, body: 'Super!')
       }
       expect(response).to render_template :edit
    end
   end
  end
  describe 'DELETE #destroy' do
    before do
      @review = FactoryGirl.create :review, user: @customer_user
    end

    context 'Deleting Review' do
      it 'deletes review if action is by owner' do
        delete :destroy, params: { id: @review }
        expect(response.status).to eq 200

      it 'does not allow to delete the review if user is manager' do
        sign_out(@customer_user)
        sign_in(@manager_user, scope: :user)
        delete :destroy, params: { id: @review }
        expect(response).to eq @response
      end

      it 'does not allow to delete the review if user is not the creator of review' do
        sign_out(@customer_user)
        deleting_user = FactoryGirl.create :user, email: 'iamgroot@gmail.com', role: 'customer'
        sign_in(deleting_user, scope: :user)
        delete :destroy, params: { id: @review }
        expect(response).to eq @response
      end
    end
  end

end

