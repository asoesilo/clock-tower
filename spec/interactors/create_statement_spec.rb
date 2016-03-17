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

  it "should create a statement" do
    expect do
      CreateStatement.call(from: 1.month.ago, to: 1.month.from_now, user: create(:user))
    end.to change(Statement, :count).by(1)
  end

  it "should assign the created statement to .statement" do
    expect(CreateStatement.call(from: 1.month.ago, to: 1.month.from_now, user: create(:user)).statement).to be_a(Statement)
  end

  context "correct paramaters" do
    before :each do
      @user = create(:user)
      3.times do
        @user.time_entries << create(:time_entry, duration_in_hours: 1, rate: 10, apply_rate: true, tax_percent: 50)
      end

      @user.time_entries << create(:time_entry, entry_date: 3.months.ago)
      @user.time_entries << create(:time_entry, entry_date: 3.months.from_now)

      @statement = CreateStatement.call(from: 1.month.ago, to: 1.month.from_now, user: @user ).statement
    end

    it "should sum up the rate * duration of the time entries and save it to subtotal" do
      expect(@statement.subtotal).to eq(30.0)
    end

    it "Caclulate the tax amount to be equal to the total hours * tax percent" do
      expect(@statement.tax_amount).to eq(15.0)
    end

    it "should associate time entries in the date range with itslef" do
      expect(@statement.time_entries.count).to eq(3)
    end

    it "should sum up the total amount of hours" do
      expect(@statement.hours).to eq(3)
    end

    it "should not add tax for time entries with has_tax false" do
      @user.time_entries << create(:time_entry, duration_in_hours: 1)
      allow(@user).to receive(:has_tax?).and_return(false)
      @user.time_entries << create(:time_entry, duration_in_hours: 1)

      statement = CreateStatement.call(from: 1.month.ago, to: 1.month.from_now, user: @user ).statement
      expect(statement.tax_amount).to eq(5)
    end

    it "should ignore time entries that are already associated to a report" do
      @user.time_entries << create(:time_entry, apply_rate: true)
      statement = CreateStatement.call(from: 1.month.ago, to: 1.month.from_now, user: @user ).statement

      expect(statement.time_entries.count).to eq(1)
    end

    it "should ignore entries that dont have apply_rate" do
      @user.time_entries << create(:time_entry, apply_rate: false)

      statement = CreateStatement.call(from: 1.month.ago, to: 1.month.from_now, user: @user ).statement
      expect(statement.time_entries.count).to eq(0)
    end
  end
end
