
include GoogleMapsHelper
class GoogleMap < ActiveRecord::Base
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# All methods called in this module is located in the google_maps_helper
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

#get_directions_json call which shall return json
  def self.get_directions_json(params)

    # get our uri key from helper method get_uri
    url_key = get_url(params)
    # get our route JSON
    jsonRoute = get_json(url_key)

  end

  # this call gets you the status code
  def self.get_json_status(jsonRoute)

    status = get_status(jsonRoute)

  end

  # gets our points
  def self.get_route_points(jsonRoute)

    points = get_points(jsonRoute)

  end
end

