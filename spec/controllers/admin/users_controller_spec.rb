require 'spec_helper'

describe Admin::UsersController do

  logged_in_user_admin

  # describe "GET #index" do
  #   it "should return an array of all users" do
  #     user = build(:user)
  #     get :index
  #     assigns(:users).should eq([user])
  #   end
  # end

  describe "GET #new" do
    it "assigns a new user to @user" do
      get :new
      assigns(:user).should be_a_new(User)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves the user to the databse" do
        expect do
          post :create, user: attributes_for(:user)
        end.to change(User, :count).by(1)
      end

      it "sets the users 'password reset required to true" do
        post :create, user: attributes_for(:user)
        expect(assigns(:user).password_reset_required).to eq(true)
      end

      it "should redirect to the admin users index" do
        post :create, user: attributes_for(:user)
        expect(response).to redirect_to(admin_users_url)
      end
    end

    context "with invalid attributes" do
      it "should not create a new user in the database" do
        expect do
          post :create, user: attributes_for(:user, email: nil)
        end.to change(User, :count).by(0)
      end

      it "should render the new template" do
        post :create, user: attributes_for(:user, email: nil)
        response.should render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    it "should load the correct User" do
      user = create(:user)
      get :edit, id: user
      assigns(:user).should eq(user)
    end
  end

  describe "PUT #update" do
    before :each do
      @user = create(:user)
    end

    context "with valid attributes" do
      it "should load correct user" do
        put :update, id: @user, user: attributes_for(:user)
        assigns(:user).should eq(@user)
      end
    
      it "should update the user with the correct values" do
        put :update, id: @user, user: attributes_for(:user, firstname: "Test_Passed")
        @user.reload
        expect(@user.firstname).to eq("Test_Passed")
      end

      it "should redirect to the admin users index" do
        put :update, id: @user, user: attributes_for(:user)
        expect(response).to redirect_to(admin_users_url)
      end
    end

    context "with invalid attributes" do
      it "should load correct user" do
        put :update, id: @user, user: attributes_for(:user, email: nil)
        assigns(:user).should eq(@user)
      end

      it "should not update the user with incorrect values" do
        put :update, id: @user, user: attributes_for(:user, firstname: nil)
        @user.reload
        expect(@user.firstname).to_not eq(nil)
      end

      it "should render the edit template" do
        put :update, id: @user, user: attributes_for(:user, firstname: nil)
        response.should render_template(:edit)
      end
    end

  end
end