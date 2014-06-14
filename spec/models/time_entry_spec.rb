require 'spec_helper'

describe TimeEntry do
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
      expect(build(:time_entry, duration_in_hours: nil)).to have(1).errors_on(:duration_in_hours)
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
end
