class Admin::LocationsController < Admin::BaseController

  before_action :load_location, only: [:show, :edit, :update, :destroy]

  def index
    @locations = Location.all
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(location_params)
    @location.creator = current_user
    if @location.save
      redirect_to admin_locations_path, notice: "#{@location.name} was successfully created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @location.update(location_params)
      redirect_to admin_locations_path, notice: "#{@location.name} was successfully created."
    else
      render :edit
    end
  end

  def destroy
    if @location.destroy
      flash[:notice] = "#{@location.name} was successfully deleted."
    else
      flash[:notice] = "#{@location.name} could not be deleted."
    end
    redirect_to [:admin, :locations]
  end

  private

  def location_params
    params.require(:location).permit(
      :name,
      :province,
      :tax_name,
      :tax_percent
    )
  end

  def load_location
    @location = Location.find(params[:id])
  end
end
