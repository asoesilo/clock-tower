describe SessionsController do
  before :each do
    @user = create(:user, password: 'test', email: 'test@email.com')
  end

  describe "POST #create" do
    context "with valid credentials" do
      it "should set the user_id session to the desired users ID" do
        post :create, email: "test@email.com", password: 'test'
        expect(session[:user_id]).to eq(@user.id)
      end

      it "should redirect to the time entry index page" do
        post :create, email: "test@email.com", password: 'test'
        expect(response).to redirect_to(new_time_entry_url)
      end
    end

    context "with invalid credentials" do
      it "should not set the user_id session" do
        post :create, email: "test@email.com", password: 'wrong'
        expect(session[:user_id]).to eq(nil)
      end

      it "should render the new template" do
        post :create, email: "test@email.com", password: 'wrong'
        expect(response).to render_template(:new)
      end
    end
  end

  describe "DELETE #destroy" do
    it "should clear the user_id session variable" do
      delete :destroy
      expect(session[:user_id]).to eq(nil)
    end

    it "should redirect to root" do
      delete :destroy
      expect(response).to redirect_to(:root)
    end
  end
end
