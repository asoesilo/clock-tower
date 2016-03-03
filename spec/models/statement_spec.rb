describe Statement do

  describe "factory" do 
    it "has a valid factory" do
      expect(build(:statement)).to be_valid
    end
    
    it "is invalid without from" do
      expect(build(:statement, from: nil)).to have(1).errors_on(:from)
    end

    it "is invalid without to" do
      expect(build(:statement, to: nil)).to have(1).errors_on(:to)
    end

    it "is invalid without a user" do
      expect(build(:statement, user_id: nil)).to have(1).errors_on(:user_id)
    end
  end

end