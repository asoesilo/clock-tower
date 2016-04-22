describe "statement:daily_lock" do
  include_context 'rake'

  it 'should use todays date' do
    expect(Date).to receive(:today).and_call_original
    subject.invoke
  end

  it "should call LockStatementsForDate with todays date" do
    today = Date.today
    expect(Date).to receive(:today).and_return(today)
    expect(LockStatementsForDate).to receive(:call).with({date: today})
    subject.invoke
  end
end
