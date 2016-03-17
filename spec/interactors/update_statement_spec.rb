describe UpdateStatement do
  before :each do
    @user = create :user,  hourly: true, rate: 10, has_tax: true
    @entry1 = create :time_entry, entry_date: Date.today, user: @user, duration_in_hours: 1
    @statement = create :statement, from: 1.month.ago, to: 1.week.from_now, time_entries: [@entry1], user: @user, hours: 1, subtotal: 10, tax_amount: 10
    @entry2 = create :time_entry, entry_date: Date.today, user: @user, duration_in_hours: 1
    @entry3 = create :time_entry, entry_date: 2.months.ago, user: @user, duration_in_hours: 1

    UpdateStatement.call(statement: @statement)
  end

  it "should not touch time entries outside of the date range" do
    @entry3.reload
    expect(@entry3.statement_id).to eq(nil)
  end

  it "should add new entries to the statement" do
    @entry2.reload
    expect(@entry2.statement_id).to eq(@statement.id)
  end

  it "should recalculate the total hours" do
    expect(@statement.hours).to eq(2)
  end

  it "should recalculate the subtotal" do
    expect(@statement.subtotal).to eq(20)
  end

  it "should recalculate the tax" do
    expect(@statement.tax_amount).to eq(0)
  end

  it "should recalculate the total to be tax amt + subtotal" do
    expect(@statement.total).to eq(20)
  end
end
