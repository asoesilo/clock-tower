describe TimeEntry do
  before :each do
    @time_entry = build(:time_entry)
  end

  after :all do
    TimeEntry.destroy_all
  end

  describe "factory" do
    it "has a valid factory" do
      expect(build(:time_entry)).to be_valid
    end

    it "is valid without comments" do
      expect(build(:time_entry, comments: nil)).to be_valid
    end

    it "is invalid without an entry date" do
      expect(build(:time_entry, entry_date: nil)).to have(1).errors_on(:entry_date)
    end

    it "is invalid without a duration" do
      expect(build(:time_entry, duration_in_hours: nil).errors_on(:duration_in_hours).size).to eq(1)
    end

    it "is invalid without a user" do
      expect(build(:time_entry, user: nil)).to have(1).errors_on(:user)
    end

    it "is invalid without a project" do
      expect(build(:time_entry, project: nil)).to have(1).errors_on(:project)
    end

    it "is invalid without a task" do
      expect(build(:time_entry, task: nil)).to have(1).errors_on(:task)
    end

  end

  describe "#set_holiday" do
    it "should take a users holiday_code and apply it to itself if the user has a location and its project doesn't" do
      allow(@time_entry.project).to receive(:location).and_return(nil)
      @time_entry.user.location = build(:location)
      allow(@time_entry.user.location).to receive(:holiday_code).and_return(:ca_bc)

      @time_entry.save      
      expect(@time_entry.holiday_code).to eq("ca_bc")
    end

    it "should take a project holiday_code and apply it to itself if the project has a location" do
      @time_entry.project.location = build(:location)
      allow(@time_entry.project.location).to receive(:holiday_code).and_return(:ca_bc)

      @time_entry.save
      expect(@time_entry.holiday_code).to eq("ca_bc")
    end

    it "should set is holiday to true if the entry date is a holiday" do 
      allow(@time_entry.entry_date).to receive(:holiday?).and_return(true)

      @time_entry.save
      expect(@time_entry.is_holiday).to eq(true)
    end
    
    it "should set is holiday to false if the entry date is not a holiday" do 
      allow(@time_entry.entry_date).to receive(:holiday?).and_return(false)

      @time_entry.save
      expect(@time_entry.is_holiday).to eq(false)
    end

    it "should set is holiday rate multiplier match the users holiday rate multiplier" do 
      allow(@time_entry.user).to receive(:holiday_rate_multiplier).and_return(3.5)

      @time_entry.save
      expect(@time_entry.holiday_rate_multiplier).to eq(3.5)
    end

    it "should set is holiday rate multiplier match the users holiday rate multiplier" do 
      allow(@time_entry.user).to receive(:holiday_rate_multiplier).and_return(nil)

      @time_entry.save
      expect(@time_entry.holiday_rate_multiplier).to eq(nil)
    end
  end

  describe "set_rate" do
    it "should take a users hourly bool and apply it to apply_rate" do
      allow(@time_entry.user).to receive(:hourly?).and_return (false)

      @time_entry.save
      expect(@time_entry.apply_rate).to eq(false)
    end

    it "should take a users hourly bool and apply it to apply_rate" do
      allow(@time_entry.user).to receive(:hourly?).and_return (true)

      @time_entry.save
      expect(@time_entry.apply_rate).to eq(true)
    end


    it "should set the rate to the users rate if the task doesn't use secondary rate and it is not a holiday" do
      @time_entry.user = build :user, rate: 10, hourly: true

      allow(@time_entry.task).to receive(:apply_secondary_rate?).and_return(false)
      allow(@time_entry).to receive(:is_holiday?).and_return(false)

      @time_entry.save
      expect(@time_entry.rate).to eq(10)
    end    

    it "should set the rate to the users rate * the users holiday rate mutlipler if the task doesn't use secondary rate and it is a holiday" do
      @time_entry.user = build :user, rate: 10, holiday_rate_multiplier: 2, hourly: true

      allow(@time_entry.task).to receive(:apply_secondary_rate?).and_return(false)
      allow(@time_entry).to receive(:is_holiday?).and_return(true)

      @time_entry.save
      expect(@time_entry.rate).to eq(20)
    end

    it "should set the rate to the users secondary rate if the task uses secondary rate and it is not a holiday" do
      @time_entry.user = build :user, secondary_rate: 10, hourly: true

      allow(@time_entry.task).to receive(:apply_secondary_rate?).and_return(true)
      allow(@time_entry).to receive(:is_holiday?).and_return(false)

      @time_entry.save
      expect(@time_entry.rate).to eq(10)
    end

    it "should set the rate to the users secondary rate if the task uses secondary rate and it is not a holiday" do
      @time_entry.user = build :user, secondary_rate: 10, holiday_rate_multiplier: 2, hourly: true

      allow(@time_entry.task).to receive(:apply_secondary_rate?).and_return(true)
      allow(@time_entry).to receive(:is_holiday?).and_return(true)

      @time_entry.save
      expect(@time_entry.rate).to eq(20)
    end
  end

  describe "#as_json" do
    it "should include id" do
      expect(@time_entry.as_json(root: false)[:id]).to eq(@time_entry.id)
    end

    it "should include user" do
      expect(@time_entry.as_json(root: false)[:user]).to_not be_nil
    end

    it "should include project" do
      expect(@time_entry.as_json(root: false)[:project]).to_not be_nil
    end

    it "should include taskb" do
      expect(@time_entry.as_json(root: false)[:task]).to_not be_nil
    end

    it "should include date" do
      expect(@time_entry.as_json(root: false)[:date]).to eq(@time_entry.entry_date)
    end

    it "should include duration" do
      expect(@time_entry.as_json(root: false)[:duration_in_hours]).to eq(@time_entry.duration_in_hours)
    end
    
    it "should include comments" do
      expect(@time_entry.as_json(root: false)[:comments]).to eq(@time_entry.comments)
    end
  end

end
