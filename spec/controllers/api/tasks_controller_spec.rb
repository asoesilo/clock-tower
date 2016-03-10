describe Api::TasksController do

  logged_in_user

  describe "#index" do
    it "should render a JSON object" do
      get :index
      expect(response.content_type).to eq("application/json")
    end

    it "should render a list of all Tasks" do
      task = build :task
      expect(Task).to receive(:all).and_return([task])
      get :index
      expect(response.body).to eq([task].to_json)
    end
  end

end