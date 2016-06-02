describe Task do
  before :each do
    @task = build(:task)
  end

  describe "factory" do
    it "has a valid factory" do
      expect(build(:task)).to be_valid
    end

    it "is invalid without a name" do
      expect(build(:task, name: nil)).to have(1).errors_on(:name)
    end

    it "is invalid with a duplicate name" do
      task = create(:task, name: "test")
      expect(build(:task, name: "test")).to have(1).errors_on(:name)
      task.destroy
    end
  end

   describe "#as_json" do
    it "should include id" do
      expect(@task.as_json(root: false)[:id]).to eq(@task.id)
    end

    it "should include name" do
      expect(@task.as_json(root: false)[:name]).to eq(@task.name)
    end
  end

  describe "#creator" do

    it "should return a User" do
      expect(@task.creator).to be_a(User)
    end

    it "should return the associated User" do
      user = build(:user)
      task = build(:task, creator: user)
      expect(task.creator).to be(user)
    end 
  end

end
