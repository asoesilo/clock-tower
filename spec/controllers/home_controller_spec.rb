require 'spec_helper'

describe HomeController do
  describe "GET show" do
    context "no logged in user" do
      it "should render the show template" do
        get :show
        expect(response).to render_template(:show)
      end
    end
    
    context "with logged in user" do
      logged_in_user
      it "should redirect to the time entries page" do
        get :show
        expect(response).to redirect_to(time_entries_url)
      end
    end
  end
end