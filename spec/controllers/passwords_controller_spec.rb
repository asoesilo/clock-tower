describe PasswordsController do
  logged_in_user

  describe "GET #edit" do
    it "should be accessable with a password update required" do
      current_user.password_reset_required = true
      get :edit
      expect(response.status).to eq(200)
    end

    it "should assign the current user to @user" do
      get :edit
      expect(assigns(:user)).to eq(current_user)
    end
  end

  describe "PUT #update" do
    before :each do
      @user = current_user
      @user.update(password: '123', password_confirmation: '123')
    end

    describe "with valid password" do
      before :each do
        @params = attributes_for(:user, password: 'test', password_confirmation: 'test')
      end

      it "should change the users password" do
        put :update, user: @params
        @user.reload
        expect(@user.authenticate('test')).to eq(@user)
      end

      it "should set the users password reset requred to false" do
        @user.password_reset_required = true
        put :update, user: @params
        @user.reload
        expect(@user.password_reset_required).to eq(false)
      end

      it "should redirect the user to the root page" do
        put :update, user: @params
        expect(response).to redirect_to(:root)
      end
    end

    describe "with an invalid password" do
      before :each do
        @params = attributes_for(:user, password: 'wrong', password_confirmation: 'test')
      end

      it "should not change the users password" do
        put :update, user: @params
        @user.reload
        expect(@user.authenticate('123')).to eq(@user)
      end

      it "should not set the users password reset requred to false" do
        @user.update password_reset_required: true
        put :update, user: @params
        @user.reload
        expect(@user.password_reset_required).to eq(true)
      end

      it "should require both a password and a confirmation" do
        put :update, user: attributes_for(:user, password: 'wrong')
        @user.reload
        expect(@user.authenticate('123')).to eq(@user)
      end

      it "should assign the current user to @user" do
        put :update, user: @params
        expect(assigns(:user)).to eq(current_user)
      end

      it "should render the edit template" do
        put :update, user: @params
        expect(response).to render_template(:edit)
      end
    end
  end
end
