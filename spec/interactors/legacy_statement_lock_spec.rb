describe LegacyStatementLock do
  before :each do
    @statement = create :statement, post_date: Date.today
    @statement.time_entries << create(:time_entry, apply_rate: true)
    @statement2 = create :statement, post_date: Date.today
    @old_statement = create :statement, post_date: 1.week.ago
    @new_statement = create :statement, post_date: 1.week.from_now
    @result = LegacyStatementLock.call(date: Date.today)
  end

  it "should change the statements state to 'legacy'" do
    expect(@statement.state).to eq('legacy')
    expect(@statement2.state).to eq('legacy')
  end

  it "should not change statements that don't end today" do
    expect(@old_statement.state).to eq('pending')
    expect(@new_statement.state).to eq('pending')
  end

end
