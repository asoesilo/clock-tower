require 'spec_helper'

describe Admin::Reports::SummaryController do
  logged_in_user_admin

  describe '#show' do

    before :each do
      3.times do
        create(:time_entry, duration_in_hours: 1)
      end
    end

    it "should allow assign @time entries to a collection of time entries" do
      allow(TimeEntry).to receive(:query).and_return(TimeEntry.all)
      get :show, from: Date.today.beginning_of_week, to: Date.today

      expect(assigns[:time_entries]).to eq(TimeEntry.all)
    end

    it "should set @total_duration to the sum of all the time entry durations" do
      allow(TimeEntry).to receive(:query).and_return(TimeEntry.all)
      get :show
      expect(assigns[:total_duration]).to eq(3)
    end

    context "@from" do
      it "should set to a date passed in as the from param" do
        get :show, from: '2016-1-1'

        expect(assigns[:from]).to eq(Date.parse('2016-1-1'))
      end

      it "should set to the start of the week if no from param is present" do
        get :show
        expect(assigns[:from]).to eq(Date.today.beginning_of_week)
      end
    end

    context "@to" do
      it "should set to a date passed in as the to param" do
        get :show, to: '2016-2-24'
        expect(assigns[:to]).to eq(Date.parse('2016-2-24'))
      end

      it "should set to today if no to param is present" do
        get :show
        expect(assigns[:to]).to eq(Date.today)
      end
    end
  end
end