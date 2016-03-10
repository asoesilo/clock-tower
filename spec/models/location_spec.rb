describe Location do
  before :each do
    @location = build :location
  end

  describe "factory" do
    it "has a valid factory" do
      expect(build(:location)).to be_valid
    end

    it "is invalid without a name" do
      expect(build(:location, name: nil)).to have(1).errors_on(:name)
    end

    it "is invalid without a province" do
      expect(build(:location, province: nil)).to have(1).errors_on(:province)
    end

    it "is invalid with an incorrect province" do
      expect(build(:location, province: "Error")).to have(1).errors_on(:province)
    end

    it "is invalid without a tax percent" do
      expect(build(:location, tax_percent: nil)).to have(1).errors_on(:tax_percent)
    end

    it "is invalid without a tax name" do
      expect(build(:location, tax_name: nil)).to have(1).errors_on(:tax_name)
    end
  end

  describe "#to_s" do
    it "should return a string with name and province" do
      expect(@location.to_s).to eq("#{@location.name} - #{@location.province}")
    end
  end

  describe "#holiday_code" do
    it "should return a symbol" do
      expect(@location.holiday_code).to be_a(Symbol)
    end

    it "should return the associated province's symbol" do
      location = build(:location, province: "Yukon")
      expect(location.holiday_code).to eq(:ca_yk)
    end
  end

  describe "#creator" do

    it "should return a User" do
      expect(@location.creator).to be_a(User)
    end

    it "should return the associated User" do
      user = build(:user)
      location = build(:location, creator: user)
      expect(location.creator).to be(user)
    end 
  end

end