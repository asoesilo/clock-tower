require 'spec_helper'

describe Admin::LocationsController do

  logged_in_user_admin

  describe "GET index" do
    it "populates an array of locations" do
      location = build(:location)
      expect(Location).to receive(:all).and_return([location])

      get :index
      expect(assigns(:locations)).to eq([location])
    end
  end

  describe "GET #new" do
    it "assigns a new location to @location" do
      get :new
      expect(assigns(:location)).to be_a_new(Location)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new time entry in the database" do
        expect do
          post :create, location: attributes_for(:location)
        end.to change(Location, :count).by(1)
      end

      it "redirects to the admin locations index" do
        post :create, location: attributes_for(:location)
        expect(response).to redirect_to(admin_locations_url)
      end
    end

    context "with invalid attributes" do
      it "should not create a new time entry in the database" do 
        expect do
          post :create, location: attributes_for(:location, name: nil)
        end.to change(Location, :count).by(0)        
      end

      it "should render the new template" do
        post :create, location: attributes_for(:location, name: nil)
        expect(response).to render_template :new
      end
    end
  end

  describe "GET #edit" do
    it "should load correct student application" do
      @location = create(:location)
      get :edit, id: @location
      expect(assigns(:location)).to eq(@location)
    end
  end

  describe "PUT #update" do
    before :each do
      @location = create(:location)
    end

    context "with valid attributes" do
      it "should load correct student application" do
        put :update, id: @location, location: attributes_for(:location)
        expect(assigns(:location)).to eq(@location)
      end

      it "should update the location with the correct values" do
        put :update, id: @location, location: attributes_for(:location, name: 'updated name')
        @location.reload
        expect(@location.name).to eq('updated name')
      end

      it "should redirect to the admin locations index" do
        put :update, id: @location, location: attributes_for(:location)
        expect(response).to redirect_to(admin_locations_url)
      end
    end

    context "with invalid attributes" do
      before :all do
        @invalid_attrs = attributes_for(:location, name: nil)
      end

      it "should load correct student application" do
        put :update, id: @location, location: @invalid_attrs
        expect(assigns(:location)).to eq(@location)
      end

      it "should not update the location" do
        put :update, id: @location, location: @invalid_attrs
        @location.reload
        expect(@location.name).to_not eq(nil)
      end

      it "should render the edit page" do
        put :update, id: @location, location: @invalid_attrs
        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE #destroy" do
    before :each do
      @location = create(:location)
    end

    it "should remove a location from the database" do
      expect do
        delete :destroy, id: @location
      end.to change(Location, :count).by(-1)
    end

    it "should redirect to the admin location index " do
      delete :destroy, id: @location
      expect(response).to redirect_to(admin_locations_url)
    end
  end
end
