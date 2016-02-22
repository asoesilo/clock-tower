module UserAccountHelpers

  module Macros
    def current_user(&user)
      let(:current_user, &user)
      before { login_as current_user }
    end

    def logged_in_user
      current_user { create(:user) }
    end

    def logged_in_user_admin
      current_user { create(:user_admin) }
    end
  end

  def login_as(user)
    allow(controller).to receive(:current_user).and_return user
  end

end
