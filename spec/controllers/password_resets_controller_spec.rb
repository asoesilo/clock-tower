describe PasswordResetsController do
  describe "POST create" do
    context "with a valid email" do
      before :each do
        @user = create(:user, email: "test@email.com")
      end

      it "should add a password_reset_token to the associated user" do
        post :create, email: "test@email.com"
        @user.reload
        expect(@user.password_reset_token).to_not be_nil
      end

      it "should send an email" do
        expect do
          post :create, email: "test@email.com"
        end.to change{ ActionMailer::Base.deliveries.count }.by(1)
      end

      it "should redirect to the root page" do
        post :create, email: "test@email.com"
        expect(response).to redirect_to(:root)
      end
    end

    context "with a invalid email" do
      before :each do
        @user = create(:user, email: "test@email.com")
      end

      it "should not change the password_reset_token" do
        token = @user.password_reset_token
        post :create, email: "invalid email"
        @user.reload
        expect(@user.password_reset_token).to eq(token)
      end

      it "should not send an email" do
        expect do
          post :create, email: "invlaid email"
        end.to_not change{ ActionMailer::Base.deliveries.count }
      end

      it "should render the new template" do
        post :create, email: "invlaid email"
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET show" do
    context "with valid password_reset_token" do

      before :each do
        @user = create(:user, password_reset_token: 'test')
      end

      it "should set the users password_reset_required to true" do
        get :show, id: 'test'
        @user.reload
        expect(@user.password_reset_required).to eq(true)
      end
      
      it "should set session user_id to the found users id" do
        get :show, id: 'test'
        expect(session[:user_id]).to eq(@user.id)
      end

      it "should redirect to the root page" do
        get :show, id: 'test'
        expect(response).to redirect_to(:edit_password)
      end
    end

    context "without valid password_reset_token" do
      it "should redirect to the root path" do
        get :show, id: 'bad id'
        expect(response).to redirect_to(:root)
      end
    end
  end

end 