require 'spec_helper'

describe User do

  describe "factory" do
    it "has a valid factory" do
      expect(build(:user)).to be_valid
    end

    it "is invalid without first name" do
      expect(build(:user, firstname: nil)).to have(1).errors_on(:firstname)
    end

    it "is invalid without last name" do
      expect(build(:user, lastname: nil)).to have(1).errors_on(:lastname)
    end

    it "is invalid without password" do
      expect(build(:user, password: nil)).to have(1).errors_on(:password)
    end

    it "is invalid without email" do
      expect(build(:user, email: nil)).to have(2).errors_on(:email)
    end

    it "is invalid without valid email" do
      expect(build(:user, email: Faker::Name.name)).to have(1).errors_on(:email)
    end
  end

  describe "#fullname" do
    it "returns a concatenation of firstname and lastname" do
      user = build(:user)
      expect(user.fullname).to eq "#{user.firstname} #{user.lastname}"
    end
  end
end
