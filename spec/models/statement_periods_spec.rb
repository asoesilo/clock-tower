describe StatementPeriod do
  describe 'factory' do
    it "should have a valid factory" do
      expect(build :statement_period).to be_valid
    end

    it "should be invalid without a from" do
      expect(build :statement_period, from: nil).to have(1).errors_on(:from)
    end

    it "should be invalid without a to" do
      expect(build :statement_period, to: nil).to have(1).errors_on(:to)
    end

    it "should be invalid without draft days" do
      expect(build :statement_period, draft_days: nil).to have(1).errors_on(:draft_days)
    end

    it "should be invalid with draft days set to less than 0" do
      expect(build :statement_period, draft_days: -3).to have(1).errors_on(:draft_days)
    end

    context "should only allow numbers up to 31 or End of Month / Start of Month for from" do
      it "should fail with numbers higher than 31" do
        expect(build :statement_period, from: 40).to have(1).errors_on(:from)
      end

      it "should fail with numbers less than 1" do
        expect(build :statement_period, from: -5).to have(1).errors_on(:from)
      end

      it "should fail with random strings" do
        expect(build :statement_period, from: 'Fail').to have(1).errors_on(:from)
      end

      it "should pass with End of Month" do
        expect(build :statement_period, from: 'End of Month').to be_valid
      end

      it "should pass with Start of Month" do
        expect(build :statement_period, from: 'Start of Month').to be_valid
      end
    end

    context "should only allow numbers up to 31 or End of Month / Start of Month for to" do
      it "should fail with numbers higher than 31" do
        expect(build :statement_period, to: 40).to have(1).errors_on(:to)
      end

      it "should fail with numbers less than 1" do
        expect(build :statement_period, to: -5).to have(1).errors_on(:to)
      end

      it "should fail with random strings" do
        expect(build :statement_period, to: 'Fail').to have(1).errors_on(:to)
      end

      it "should pass with End of Month" do
        expect(build :statement_period, to: 'End of Month').to be_valid
      end

      it "should pass with Start of Month" do
        expect(build :statement_period, to: 'Start of Month').to be_valid
      end
    end
  end

  describe "#from_date" do
    it "should return a date with the same day of the month as the from" do
      period = create :statement_period, from: '1'
      date = 1.day.ago
      expect(period.from_date(date)).to eq(Date.new(date.year, date.month, 1).beginning_of_day)
    end

    it "should return a date based off of the month / year of the date passed in" do
      period = create :statement_period, from: '5'
      date = 1.month.ago
      expect(period.from_date(date)).to eq(Date.new(date.year, date.month, 5).beginning_of_day)
    end

    it "should return the beginning of month properly" do
      period = create :statement_period, from: 'Start of Month'
      date = 1.day.ago
      expect(period.from_date(date)).to eq(date.beginning_of_month.beginning_of_day)
    end

    it "should return the end of month properly" do
      period = create :statement_period, from: 'End of Month'
      date = 1.day.ago
      expect(period.from_date(date)).to eq(date.end_of_month.beginning_of_day)
    end
  end

  describe "#to_date" do
    it "should return a date with the same day of the month as the from, at the end of the day" do
      period = create :statement_period, to: '10'
      date = 1.day.from_now
      expect(period.to_date(date)).to eq(Date.new(date.year, date.month, 10).end_of_day)
    end

    it "should return a date based off of the month / year of the date passed in" do
      period = create :statement_period, to: '23'
      date = 1.month.from_now
      expect(period.to_date(date)).to eq(Date.new(date.year, date.month, 23).end_of_day)
    end

    it "should return the beginning of month properly" do
      period = create :statement_period, to: 'Start of Month'
      date = 1.day.from_now
      expect(period.to_date(date)).to eq(date.beginning_of_month.end_of_day)
    end

    it "should return the end of month properly" do
      period = create :statement_period, to: 'End of Month'
      date = 1.day.from_now
      expect(period.to_date(date)).to eq(date.end_of_month.end_of_day)
    end
  end

  describe "#draft_end_date" do
    it "should return a date #draft_days past the to date" do
      period = create :statement_period, to: 1.day.from_now.day, draft_days: 1
      date = 1.day.from_now
      expect(period.draft_end_date(date)).to eq(date.advance(days: 1).end_of_day)
    end
  end

end
