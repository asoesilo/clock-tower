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

    it "is invalid without a subtotal" do
      expect(build(:statement, subtotal: nil)).to have(1).errors_on(:subtotal)
    end

    it "is invalid without a tax_amount" do
      expect(build(:statement, tax_amount: nil)).to have(1).errors_on(:tax_amount)
    end

    it "is invalid without hours" do
      expect(build(:statement, hours: nil)).to have(1).errors_on(:hours)
    end

    it "is invalid without total" do
      expect(build(:statement, total: nil)).to have(1).errors_on(:total)
    end
  end

  describe "#state_machine" do
    before :each do
      @statement = create :statement
    end

    it "should return an instance of the statement state machien class" do
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