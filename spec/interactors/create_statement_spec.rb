describe CreateStatement do
  context "reqiured context" do
    it "should fail if there is no to set" do
      expect(CreateStatement.call(from: 1.month.ago, user: build(:user)).failure?).to eq(true)
    end

    it "should fail if there is no from set" do
      expect(CreateStatement.call(to: 1.month.from_now, user: build(:user)).failure?).to eq(true)
    end

    it "should fail if there is no user set" do
      expect(CreateStatement.call(from: 1.month.ago, to: 1.month.from_now).failure?).to eq(true)
    end

  end
end