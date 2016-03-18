describe UpdateTimeEntry do
  def set_params
    @params = {
      time_entry: @entry,
      project_id: @project.id,
      task_id: @task.id,
      duration_in_hours: @duration,
      entry_date: @entry_date.to_s,
      comments: @comments
    }
  end

  before :each do
    @location = create :location
    @user = create :user, rate: 10, hourly: true, secondary_rate: 20, holiday_rate_multiplier: 2
    @project = create :project
    @task = create :task
    @duration = 1
    @entry_date = Date.today
    @comments = "Test Comment"
    @entry = create :time_entry, project: @project, task: @task, entry_date: @entry_date, duration_in_hours: @duration, comments: @comments, user: @user, location: @location

    set_params
  end

  context "required context" do
    it "should succeed with all the required context" do
      expect(UpdateTimeEntry.call(@params).success?).to eq(true)
    end
  end

  context "with new duration_in_hours" do
    before :each do
      @duration = 2
      set_params
      @entry = UpdateTimeEntry.call(@params).time_entry
    end

    it "should change the duration in hours" do
      expect(@entry.duration_in_hours).to eq(2)
    end
  end

  context "with new task" do
    before :each do
      @task = create :task, apply_secondary_rate: true
      set_params
      @entry = UpdateTimeEntry.call(@params).time_entry
    end

    it "should change the associated task" do
      expect(@entry.task).to eq(@task)
    end

    it "should change the rate if the tasks apply_secondary_rate is different + user has secondary_rate" do
      expect(@entry.rate).to eq(20)
    end
  end

  context "with new project" do
    before :each do
      @location = create :location
      @project = create :project, location: @location
      set_params
      @entry = UpdateTimeEntry.call(@params).time_entry
    end

    it "should change the associated project" do
      expect(@entry.project).to eq(@project)
    end

    it "should change the location to the projects location if it has one" do
      expect(@entry.location).to eq(@location)
    end

    context "data derived from location" do
      it "should change the tax desc to the locations" do
        expect(@entry.tax_desc).to eq(@location.tax_name)
      end

      it "should change the tax percent to the locations" do
        expect(@entry.tax_percent).to eq(@location.tax_percent)
      end

      it "should change the holiday_code to the locations" do
        expect(@entry.holiday_code).to eq(@location.holiday_code.to_s)
      end
    end
  end

  context "with new entry_date" do
    it "should chage the entry date" do
      @entry_date = DateTime.new(2012, 4, 5)
      set_params
      @entry = UpdateTimeEntry.call(@params).time_entry

      expect(@entry.entry_date).to eq(@entry_date)
    end

    context "that is a holiday" do
      before :each do
        @entry_date = Date.new(2016, 12, 25)
        set_params
        @entry = UpdateTimeEntry.call(@params).time_entry
      end

      it "should set the is_holiday bool to true" do
        expect(@entry.is_holiday).to eq(true)
      end

      it "should recalculate the rate" do
        expect(@entry.rate).to eq(20)
      end
    end
  end

  context "with new comments" do
    before :each do
      @comments = "I got changed!"
      set_params
      @entry = UpdateTimeEntry.call(@params).time_entry
    end

    it "should change the comments" do
      expect(@entry.comments).to eq(@comments)
    end
  end
end
