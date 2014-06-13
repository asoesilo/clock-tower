require 'spec_helper'

describe User do
  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

  it "does not allow user with invalid email" do
    user = build(:user_invalid_email)
    user.should_not be_valid
  end

  describe "#fullname" do
    it "returns a concatenation of firstname and lastname" do
      user = create(:user)
      expect(user.fullname).to eq "#{user.firstname} #{user.lastname}"
    end
  end
end
