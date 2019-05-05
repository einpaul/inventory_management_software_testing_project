require 'rails_helper'
# frozen_string_literal: true
RSpec.describe ReviewsController, type: :controller do

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
    sign_in(@customer_user, scope: :user)
    @response = "You have requested a page that you do not have access to."
    @review_attributes = FactoryGirl.attributes_for(:review)
    @review_data = read_fixture_file('review.json')
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
        expect { post :create, params: { review: @review_attributes }}.to change(Review, :count).by(1)
      end

      it 'redirects to customer home' do
        post :create, params: { review: @review_attributes }
        expect(response).to redirect_to root_path
      end

      it 'the created review gets assigned to the currently logged in user' do
        post :create, params: { review: @review_attributes }
        expect(Review.last.user).to eq @customer_user
      end

      it 'will not allow to create review if user is manager or salesperson' do
        sign_out(@customer_user)
        sign_in(@manager_user, scope: :user)
        post :create, params: { review: @review_attributes }
        expect(response).to eq @response
      end
    end

    context "with invalid attributes" do
      before do
        @invalid_review_attributes = FactoryGirl.attributes_for(:review,
                                                                rating: @review_data["invalid_review_attributes"]["rating"])
      end

      it 'does not save the new review in the database' do
        review_params = { review: @invalid_review_attributes }
        expect { post :create, params: review_params }.to_not change(Review, :count)
      end

      it 're-renders the :new template' do
        post :create, params: { review: @invalid_review_attributes }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before do
      @review = FactoryGirl.create :review, user: @customer_user
    end

   context 'valid attributes' do
    before do
      @valid_review_update_attributes = FactoryGirl.attributes_for(:review,
                                                                    rating: @review_data["valid_review_update_attributes"]["rating"],
                                                                    body: @review_data["valid_review_update_attributes"]["body"])
    end

     it 'locates the requested @review' do
      patch :update, params: { id: @review, review: @review_attributes }
      expect(assigns(:review)).to eq(@review)
     end

    it 'changes @review\'s attributes' do
      patch :update, params: {
        id: @review,
        review: @valid_review_update_attributes
      }
      @review.reload
      expect(@review.rating).to eq(@review_data["valid_review_update_attributes"]["rating"])
      expect(@review.body).to eq(@review_data["valid_review_update_attributes"]["body"])
    end

    it 'redirects to the updated review' do
      patch :update, params: { id: @review, review: @review_attributes }
      expect(response).to redirect_to reviews_path
    end

    it 'does not update the review if user is manager' do
      sign_out(@customer_user)
      sign_in(@manager_user, scope: :user)
      patch :update, params: {
        id: @review,
        review: @valid_review_update_attributes
      }
      expect(response).to eq @response
    end
   end

   context 'invalid attributes' do
    before do
      @invalid_review_update_attributes = FactoryGirl.attributes_for(:review,
                                                                      rating: @review_data["invalid_review_update_attributes"]["rating"],
                                                                      body: @review_data["invalid_review_update_attributes"]["body"])
    end

    it 'locates the requested @review' do
      patch :update, params: { id: @review, review: @review_attributes }
      expect(assigns(:review)).to eq(@review)
    end

    it 'does not change @review\'s attributes' do
      patch :update, params: {
        id: @review,
        review: @invalid_review_update_attributes
      }
      @review.reload
      expect(@review.rating).to eq(@review_data["review_factory_attrs"]["rating"])
      expect(@review.body).to_not eq(@review_data["invalid_review_update_attributes"]["body"])
    end

    it 're-renders the edit method' do
      patch :update, params: {
          id: @review,
          review: @invalid_review_update_attributes
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
        expect { delete :destroy, params: { id: @review } }.to change(Review, :count).by(-1)
      end

      it 'does not allow to delete the review if user is manager' do
        sign_out(@customer_user)
        sign_in(@manager_user, scope: :user)
        delete :destroy, params: { id: @review }
        expect(response).to eq @response
      end

      it 'does not allow to delete the review if user is not the creator of review' do
        sign_out(@customer_user)
        deleting_user = FactoryGirl.create :user,
                                            email: @user_data["review_deleting_user"]["email"],
                                            role: @user_data["review_deleting_user"]["role"]
        sign_in(deleting_user, scope: :user)
        delete :destroy, params: { id: @review }
        expect(response).to eq @response
      end
    end
  end
end


