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

  it "should not be editable on a locked statement" do
    entry = create :time_entry
    statement = create :statement
    allow(entry).to receive(:statement).and_return(statement)
    allow(statement).to receive(:state).and_return('locked')

    expect(entry).to have(1).errors_on(:statement)
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
