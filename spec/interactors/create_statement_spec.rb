describe CreateStatement do
  context "reqiured context" do
    it "should fail if there is no to set" do
      expect(CreateStatement.call(from: 1.month.ago, user: build(:user), post_date: 2.months.from_now).failure?).to eq(true)
    end

    it "should fail if there is no from set" do
      expect(CreateStatement.call(to: 1.month.from_now, user: build(:user), post_date: 2.months.from_now).failure?).to eq(true)
    end

    it "should fail if there is no user set" do
      expect(CreateStatement.call(from: 1.month.ago, to: 1.month.from_now, post_date: 2.months.from_now).failure?).to eq(true)
    end

    it "should fail if there is no post date set" do
      expect(CreateStatement.call(from: 1.month.ago, to: 1.month.from_now, user: build(:user)).failure?).to eq(true)
    end
  end

  it "should create a statement" do
    expect do
      CreateStatement.call(from: 1.month.ago, to: 1.month.from_now, user: create(:user), post_date: 2.months.from_now)
    end.to change(Statement, :count).by(1)
  end

  it "should assign the created statement to .statement" do
    expect(CreateStatement.call(from: 1.month.ago, to: 1.month.from_now, post_date: 2.months.from_now, user: create(:user)).statement).to be_a(Statement)
  end

  context "correct paramaters" do
    before :each do
      @user = create(:user)
      3.times do
        @user.time_entries << create(:time_entry, duration_in_hours: 1, rate: 10, apply_rate: true, tax_percent: 50, has_tax: true)
      end

      @user.time_entries << create(:time_entry, entry_date: 3.months.ago)
      @user.time_entries << create(:time_entry, entry_date: 3.months.from_now)

      @statement = CreateStatement.call(from: 1.month.ago, to: 1.month.from_now, post_date: 2.months.from_now, user: @user ).statement
    end

    it "should ignore time entries that are already associated to a report" do
      @user.time_entries << create(:time_entry, apply_rate: true)
      statement = CreateStatement.call(from: 1.month.ago, to: 1.month.from_now, post_date: 2.months.from_now, user: @user ).statement

      expect(statement.time_entries.count).to eq(1)
    end

    it "should email the user if the total $ > 0" do
      te = create(:time_entry, apply_rate: true, rate: 5, duration_in_hours: 10)
      @user.time_entries << te
      expect do
        CreateStatement.call(from: 1.month.ago, to: 1.month.from_now, post_date: 2.months.from_now, user: @user )
      end.to change{ ActionMailer::Base.deliveries.count }.by(1)
    end

    it "should not email the user if the total $ == 0" do
      expect do
        CreateStatement.call(from: 1.month.ago, to: 1.month.from_now, post_date: 2.months.from_now, user: @user )
      end.to change{ ActionMailer::Base.deliveries.count }.by(0)
    end
  end
end
