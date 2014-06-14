require 'spec_helper'

describe Task do
  describe "factory" do
    it "has a valid factory" do
      expect(build(:task)).to be_valid
    end

    it "is invalid without a name" do
      expect(build(:task, name: nil)).to have(1).errors_on(:name)
    end
  end
end
