describe "statement:daily_create" do
  include_context 'rake'

  it 'should use todays date with no arguments' do
    expect(Date).to receive(:today).and_call_original
    subject.invoke
  end

  it 'should look for statement periods ending today' do
    expect(StatementPeriod).to receive(:where).and_return([build(:statement_period)])
    subject.invoke
  end

  it "should not call CreateStatementsForPeriod if no period is found" do
    expect(CreateStatementsForPeriod).to_not receive(:call)
    subject.invoke
  end

  it "should call CreateStatementsForPeriod with the period if it finds one" do
    period = create(:statement_period)
    allow(StatementPeriod).to receive(:where).and_return([period])
    expect(CreateStatementsForPeriod).to receive(:call).with({statement_period: period})
    subject.invoke
  end
end
