describe Reports::EntriesController do
  logged_in_user

  describe "GET #show" do
    it "should assign @from to the beginning of week if params :from is not present" do
      get :show
      expect(assigns[:from]).to eq(Date.today.beginning_of_week)
    end

    it "should assign @from to the date provided in params :from" do
      get :show, from: "2016-01-01"
      expect(assigns[:from]).to eq(Date.parse('2016-01-01'))
    end

    it "should assign @to to today if params :to is not present" do
      get :show
      expect(assigns[:to]).to eq(Date.today)
    end

    it "should assign @to to the date provided in params :to" do
      get :show, to: "2016-03-04"
      expect(assigns[:to]).to eq(Date.parse('2016-03-04'))
    end

    it "should set entries to a hash" do
      get :show
      expect(assigns[:entries]).to be_a(Hash)
    end

    it "should set entries[:regular] to an array" do
      get :show
      expect(assigns[:entries][:regular]).to be_a(Array)
    end

    it "should set entries[:holiday] to an array" do
      get :show
      expect(assigns[:entries][:holiday]).to be_a(Array)
    end
  end

end