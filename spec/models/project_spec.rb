describe Project do
  before :each do
    @project = build(:project)
  end

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

    it "is invalid with a duplicate name" do
      proj = create(:project, name: 'Work')
      expect(build(:project, name: 'Work')).to have(1).errors_on(:name)
      proj.destroy
    end
  end

  describe "#as_json" do
    it "should include id" do
      expect(@project.as_json(root: false)[:id]).to eq(@project.id)
    end

    it "should include name" do
      expect(@project.as_json(root: false)[:name]).to eq(@project.name)
    end
  end

  describe "#creator" do

    it "should return a User" do
      expect(@project.creator).to be_a(User)
    end

    it "should return the associated User" do
      user = build(:user)
      project = build(:project, creator: user)
      expect(project.creator).to be(user)
    end 
  end

end
