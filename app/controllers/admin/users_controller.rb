module Admin
  class UsersController < AdminController
    skip_before_action :authenticate_user, only: [:new, :create]

    def index
      @users = User.all
    end

    def new
      @user = User.new
      @path = admin_users_path
    end

    def create
      @user = User.new(user_params)

      if @user.save
        redirect_to admin_users_path
      else
        render :new
      end
    end

    protected
    def user_params
      params.require(:user).permit(:email, :firstname, :lastname, :password, :password_confirmation, :is_admin)
    end
  end
end
