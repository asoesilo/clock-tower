class Admin::UsersController < Admin::BaseController
  skip_before_action :authenticate_user, only: [:new, :create]

  def index
    @users = User.order(active: :desc, is_admin: :desc, id: :desc).all
  end

  def new
    @user = User.new
    @path = admin_users_path
  end

  def edit
    @user = User.find params[:id]
  end

  def update
    @user = User.find params[:id]
    if @user.update(user_params)
      redirect_to :index, notice: 'User updated'
    else
      render :edit
    end
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
    params.require(:user).permit(
      :email, 
      :firstname, 
      :lastname, 
      :password, 
      :password_confirmation, 
      :is_admin,
      :active,
      :rate,
      :secondary_rate,
      :hourly,
      :holiday_rate_multiplier
    )
  end
end
