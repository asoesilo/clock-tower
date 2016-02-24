module LocationsHelper

  def locations_select_options
    Location.all.map do |location|
      [location.to_s, location.id]
    end
  end

end
