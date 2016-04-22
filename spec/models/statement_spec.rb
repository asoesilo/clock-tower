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

    it "is invalid without post_date" do
      expect(build(:statement, post_date: nil)).to have(1).errors_on(:post_date)
    end
  end

  context "aggregate functions" do
    before :each do
      @user = create :user
      @statement = create :statement
      3.times do
        @statement.time_entries << (create(:time_entry, duration_in_hours: 1, apply_rate: true, rate: 10, has_tax: true, tax_percent: 50))
      end
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
      @user.time_entries << create(:time_entry, duration_in_hours: 1, apply_rate: true, has_tax: false)
      @user.time_entries << create(:time_entry, duration_in_hours: 1, apply_rate: true, has_tax: true, tax_percent: 50, rate: 10)

      statement = CreateStatement.call(from: 1.month.ago, to: 1.month.from_now, post_date: 2.months.from_now, user: @user ).statement
      expect(statement.tax_amount).to eq(5)
    end
  end

  describe "#state_machine" do
    before :each do
      @statement = create :statement
    end

    it "should return an instance of the statement state machine class" do
      expect(@statement.state_machine).to be_a(StatementStateMachine)
    end
  end

  describe ".transition_class" do
    it "should return StatementTransition" do
      expect(Statement.transition_class).to eq(StatementTransition)
    end
  end

  describe ".initial_state" do
    it "should return :pending" do
      expect(Statement.initial_state).to eq(:pending)
    end
  end
end
