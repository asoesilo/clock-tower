describe LockStatementsForDate do
  before :each do
    @statement = create :statement, post_date: Date.today
    @statement2 = create :statement, post_date: Date.today
    @old_statement = create :statement, post_date: Date.yesterday
    @new_statement = create :statement, post_date: Date.yesterday
    @result = LockStatementsForDate.call(date: Date.today)
  end

  it "should change the statements state to 'locked'" do
    expect(@statement.state).to eq('locked')
  end

  it "should not change statements that don't end today" do
    expect(@old_statement.state).to eq('pending')
    expect(@new_statement.state).to eq('pending')
  end

  it "should change all statements for that date" do
    expect(@statement2.state).to eq('locked')
  end
end
