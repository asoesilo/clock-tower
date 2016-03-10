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
end