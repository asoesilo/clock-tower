describe Api::TimeEntriesController do
  logged_in_user

  describe "#index" do
    before :each do
      current_user.time_entries << build(:time_entry, duration_in_hours: 1)
      current_user.time_entries << build(:time_entry, duration_in_hours: 2)
      get :index
      @res = ActiveSupport::JSON.decode(response.body)
    end

    it "should render a JSON object" do
      expect(response.content_type).to eq("application/json")
    end

    it "should get the total count of all the current users time entries" do
      expect(@res["num_entries"]).to eq(2)
    end

    it "should get all of the current users time entries" do
      expect(@res["entries"].length).to eq(2)
    end

    it "should get sum of all the users time entries duration as total_hours" do
      expect(@res["total_hours"]).to eq(3)
    end
  end

  describe "create" do
    context "with valid attributes" do
      before :each do
        @params = build(:time_entry).attributes.symbolize_keys
      end

      it "should save the new entry in the database" do
        expect do
          post :create, time_entry: @params
        end.to change(TimeEntry, :count).by(1)
      end

      it "responds with the new time entry in json format" do
        post :create, time_entry: @params
        expect(response.content_type).to eq("application/json")
      end
    end

    context "with invalid attributes" do
      before :each do
        @params = attributes_for(:time_entry)
      end

      it "should not save the new entry in the database" do
        expect do
          post :create, time_entry: @params
        end.to change(TimeEntry, :count).by(0)
      end

      it "should respond with error messages" do
        post :create, time_entry: @params
        @res = ActiveSupport::JSON.decode(response.body)

        expect(@res).to include('errors')
      end
    end
  end

  describe "#update" do
    before :each do
      @time_entry = create :time_entry
      current_user.time_entries << @time_entry
    end


    context "with valid attributes" do

      it "should respond with json type" do
        put :update, id: @time_entry, time_entry: attributes_for(:time_entry)
        expect(response.content_type).to eq("application/json")
      end

      it "should change the attributes of the time entry" do
        put :update, id: @time_entry, time_entry: attributes_for(:time_entry, comments: "It works!")
        @time_entry.reload
        expect(@time_entry.comments).to eq("It works!")
      end

      it "should respond with the updated time entry in json" do
        put :update, id: @time_entry, time_entry: attributes_for(:time_entry, duration_in_hours: 2)
        @res = ActiveSupport::JSON.decode(response.body)
        expect(@res["entry"]["duration_in_hours"]).to eq(2)
      end
    end

    context "with invalid attributes" do

      it "should respond with json type" do
        put :update, id: @time_entry, time_entry: attributes_for(:time_entry, duration_in_hours: nil)
        expect(response.content_type).to eq("application/json")
      end
      
      it "should not change the attributes of the time entry" do 
        put :update, id: @time_entry, time_entry: attributes_for(:time_entry, duration_in_hours: nil)
        @time_entry.reload
        expect(@time_entry.duration_in_hours).to_not eq(nil)
      end

      it "should not change the attributes of the time entry" do
        put :update, id: @time_entry, time_entry: attributes_for(:time_entry, duration_in_hours: nil)
        @res = ActiveSupport::JSON.decode(response.body)

        expect(@res).to include('errors')      
      end
    end
  end

  describe "#destroy" do

    before :each do
      @time_entry = create :time_entry
      current_user.time_entries << @time_entry
    end

    it "should destroy a time entry" do
      expect do
        delete :destroy, id: @time_entry
      end.to change(TimeEntry, :count).by(-1)
    end

    it "should respond with status 200" do
      delete :destroy, id: @time_entry
      expect(response.status).to eq(200)
    end
  end

end
