require 'spec_helper'

describe User do
  before :each do 
    @user = build(:user)
  end

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

    it "is invalid with a duplicate email" do
      user = create(:user, email: "test@example.com")
      expect(build(:user, email: "test@example.com")).to have(1).errors_on(:email)
      user.destroy
    end
  end

  describe "#fullname" do
    it "returns a concatenation of firstname and lastname" do
      expect(@user.fullname).to eq "#{@user.firstname} #{@user.lastname}"
    end
  end

  describe "#as_json" do
    it "should include id" do
      expect(@user.as_json(root: false)[:id]).to eq(@user.id)
    end

    it "should include first name" do
      expect(@user.as_json(root: false)[:firstname]).to eq(@user.firstname)
    end

    it "should include last name" do
      expect(@user.as_json(root: false)[:lastname]).to eq(@user.lastname)
    end

    it "should include last name" do
      expect(@user.as_json(root: false)[:fullname]).to eq(@user.fullname)
    end

    it "should include email" do
      expect(@user.as_json(root: false)[:email]).to eq(@user.email)
    end
  end

end
