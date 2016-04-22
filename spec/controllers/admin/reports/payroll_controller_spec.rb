describe Admin::Reports::PayrollController do
  logged_in_user_admin

  describe "GET show" do
    before :each do
      @chrispy = create(:user, hourly: true, firstname: "Chris", lastname: "Brooks")
      @gg = create(:user, hourly: true, firstname: "Graham", lastname: "Grochowski")
      @tsang = create(:user, hourly: true, firstname: "Andrew", lastname: "Tsang")
      @don = create(:user, hourly: false, firstname: "Don", lastname: "Burks")
    end

    context "@from" do
      it "should default to the beginning of week if no param from is present" do
        get :show
        expect(assigns[:from]).to eq(Date.today.beginning_of_week)
      end

      it "should set to a date passed in through the from param" do
        get :show, from: "2015-1-1"
        expect(assigns[:from]).to eq(Date.parse("2015-1-1"))
      end
    end

    context "@to" do
      it "should default to today if no param to is present" do
        get :show
        expect(assigns[:to]).to eq(Date.today)
      end

      it "should set to a date passed in through the to param" do
        get :show, to: "2015-1-1"
        expect(assigns[:to]).to eq(Date.parse("2015-1-1"))
      end
    end

    context "users" do
      context "@all_users" do
        it "should be set to all hourly users" do
          get :show
          expect(assigns[:all_users]).to include(@chrispy)
          expect(assigns[:all_users]).to include(@gg)
          expect(assigns[:all_users]).to include(@tsang)
        end

        it "should be orderd by lastname, then firstname" do
          get :show
          expect(assigns[:all_users][0]).to eq(@chrispy)
        end
      end

      context "@users" do
        it "should set to nil if there is no params users" do
          get :show
          expect(assigns[:users]).to eq(nil)
        end

        it "should set to the users by ids passed into params[:users]" do
          get :show, users: [@chrispy.id]
          expect(assigns[:users]).to eq([@chrispy])
        end
      end

      context "@reporting_users" do
        it "should set to all users if there is no params users" do
          get :show
          expect(assigns[:reporting_users]).to eq(assigns[:all_users])
        end

        it "should set to all users if there is no params users" do
          get :show, users: [@gg.id, @chrispy.id]
          expect(assigns[:reporting_users]).to eq(assigns[:users])
        end
      end
    end

    context "@entries_by_user" do
      it "should be a hash containing all reporting users" do
        get :show
        expect(assigns[:entries_by_user].keys).to include(@chrispy.id.to_s)
        expect(assigns[:entries_by_user].keys).to include(@gg.id.to_s)
        expect(assigns[:entries_by_user].keys).to include(@tsang.id.to_s)
      end

      context "entries" do
        it "should contain regular" do
          get :show
          expect(assigns[:entries_by_user][@gg.id.to_s][:regular]).to_not eq(nil)
        end

        it "should contain holiday" do
          get :show
          expect(assigns[:entries_by_user][@gg.id.to_s][:holiday]).to_not eq(nil)
        end
      end
    end
  end
end