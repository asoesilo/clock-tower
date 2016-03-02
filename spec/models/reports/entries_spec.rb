require 'spec_helper'

describe Reports::Entries do

  describe ".new" do
    it "should initialize with 3 arguments" do
      expect{ Reports::Entries.new('to', 'from', 'student') }.to_not raise_exception
    end
  end

  describe "#regular_entries_for" do
    before :each do
      @user = create :user, rate: 10, hourly: true
      @project = create :project
      @task = create :task

      4.times do 
        @user.time_entries << create(:time_entry, project: @project, task: @task, duration_in_hours: 1)  
      end

      @entry = Reports::Entries.new(1.day.ago, 1.day.from_now, @user)
    end

    describe "arguments" do
      it "should be callable with 0 arguments" do
        expect{ @entry.regular_entries_for }.to_not raise_exception
      end

      it "should be callable with 1 arguments" do
        expect{ @entry.regular_entries_for([1]) }.to_not raise_exception
      end

      it "should be callable with 2 arguments" do 
        expect{ @entry.regular_entries_for([1],[2]) }.to_not raise_exception
      end

      it "should return an array" do
        expect( @entry.regular_entries_for ).to be_a(Array)
      end
    end

    describe "array entries" do
      it "should have a task" do
        expect( @entry.regular_entries_for[0][:task] ).to_not eq(nil)
      end

      it "should have a project" do
        expect( @entry.regular_entries_for[0][:project] ).to_not eq(nil)
      end

      it "should have holiday set to false" do
        expect( @entry.regular_entries_for[0][:holiday] ).to eq(false)
      end

      it "should have hours" do
        expect( @entry.regular_entries_for[0][:hours] ).to_not eq(nil)
      end

      it "should have rate" do
        expect( @entry.regular_entries_for[0][:rate] ).to_not eq(nil)
      end
    end

    it "should sum up all the hours for a task / project / rate combo" do
      expect(@entry.regular_entries_for[0][:hours]).to eq(4)
    end

    it "should exclude time entries not in its date range" do
      @user.time_entries << create(:time_entry, project: @project, task: @task, entry_date: 1.month.ago, duration_in_hours: 1)
      expect(@entry.regular_entries_for[0][:hours]).to eq(4)
    end

    it "should exclude time entries on a holiday" do
      te = build(:time_entry, project: @project, task: @task, duration_in_hours: 1)
      allow(te.entry_date).to receive(:holiday?).and_return(true)
      te.save
      @user.time_entries << te

      expect(@entry.regular_entries_for[0][:hours]).to eq(4)
    end

    it "should have two entries if there are two combos of task rate project" do
      @user.time_entries << build(:time_entry)

      expect(@entry.regular_entries_for.count).to eq(2)
    end
  end

  describe "#holiday_entries_for" do
    before :each do
      @user = create :user, rate: 10, hourly: true
      @project = create :project
      @task = create :task

      5.times do
        te = build(:time_entry, project: @project, task: @task, duration_in_hours: 1)
        allow(te.entry_date).to receive(:holiday?).and_return(true)
        @user.time_entries << te
      end

      @entry = Reports::Entries.new(1.day.ago, 1.day.from_now, @user)
    end

    it "should sum up all the hours for a task / project / rate combo" do
      expect(@entry.holiday_entries_for[0][:hours]).to eq(5)
    end

    it "should exclude time entries not in its date range" do
      @user.time_entries << create(:time_entry, project: @project, task: @task, entry_date: 1.month.ago, duration_in_hours: 1)
      expect(@entry.holiday_entries_for[0][:hours]).to eq(5)
    end

    it "should exclude time entries not on a holiday" do
      @user.time_entries << create(:time_entry, project: @project, task: @task, duration_in_hours: 1)  

      expect(@entry.holiday_entries_for[0][:hours]).to eq(5)
    end

    it "should have two entries if there are two combos of task rate project" do
      te = build(:time_entry)
      allow(te.entry_date).to receive(:holiday?).and_return(true)
      @user.time_entries << te

      expect(@entry.holiday_entries_for.count).to eq(2)
    end

    describe "arguments" do
      it "should be callable with 0 arguments" do
        expect{ @entry.holiday_entries_for }.to_not raise_exception
      end

      it "should be callable with 1 arguments" do
        expect{ @entry.holiday_entries_for([1]) }.to_not raise_exception
      end

      it "should be callable with 2 arguments" do 
        expect{ @entry.holiday_entries_for([1],[2]) }.to_not raise_exception
      end

      it "should return an array" do
        expect( @entry.holiday_entries_for ).to be_a(Array)
      end
    end

    describe "array entries" do
      it "should have a task" do
        expect( @entry.holiday_entries_for[0][:task] ).to_not eq(nil)
      end

      it "should have a project" do
        expect( @entry.holiday_entries_for[0][:project] ).to_not eq(nil)
      end

      it "should have holiday set to false" do
        expect( @entry.holiday_entries_for[0][:holiday] ).to eq(true)
      end

      it "should have hours" do
        expect( @entry.holiday_entries_for[0][:hours] ).to_not eq(nil)
      end

      it "should have date" do
        expect( @entry.holiday_entries_for[0][:date] ).to_not eq(nil)
      end

      it "should have holiday_code" do
        expect( @entry.holiday_entries_for[0][:holiday_code] ).to_not eq(nil)
      end

      it "should have rate" do
        expect( @entry.holiday_entries_for[0][:rate] ).to_not eq(nil)
      end
    end

  end
end
