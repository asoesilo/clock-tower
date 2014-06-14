require 'spec_helper'

describe Project do

  describe "factory" do
    it "has a valid factory" do
      expect(build(:project)).to be_valid
    end

    it "is invalid without a name" do
      expect(build(:project, name: nil)).to have(1).errors_on(:name)
    end

    it "is invalid without a creator" do
      expect(build(:project, creator: nil)).to have(1).errors_on(:creator)
    end
  end
end
