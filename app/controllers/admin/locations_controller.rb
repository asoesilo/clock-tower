class Admin::LocationsController < Admin::BaseController

  def index
    @locations = Location.all
  end

  def new
    @location = Location.new
  end

  private

  def load_location
    @location = Location.find(params[:id])
  end
end
