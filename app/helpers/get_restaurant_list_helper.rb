module GetRestaurantListHelper
include GoogleMapsHelper
  # Returns the full title on a per-page basis.
def self.get_google_maps(params)
  return GoogleMaps.get_directions_json(params)
end

# Returns the route boxes response

  def self.get_route_points(mapsfromGoogleRoutes)
    return GoogleMaps.get_route_points(mapsfromGoogleRoutes)
  end

  def self.get_geostop(mapsfromGoogleRoutes)
    return GoogleMaps.get_geostop(mapsfromGoogleRoutes)
  end
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#Name:	get_valid_hash
#Description: This function will determine which point(s) to use on a
# route for directions and routeboxer based on whether the user
# specified a distance or not and whether we have a valid location
# or not.
#Params:	mapsfromGoogleRoutes - The return value of the GoogleRoutes
# class
#Return:	the directions of what we're interested in, whether that is the
# geolocation of x time/distance into the route or the directions along
# the route
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
def self.get_valid_hash(mapsfromGoogleRoutes)
  if(GoogleMapsHelper.get_geostop(mapsfromGoogleRoutes) != nil)
    return GoogleMapsHelper.get_geostop(mapsfromGoogleRoutes)
  end
  return GoogleMapsHelper.get_direction(mapsfromGoogleRoutes)
end

  def self.get_status_of_map(mapsfromGoogleRoutes)
   return GoogleMapsHelper.get_status(GetRestaurantListHelper.get_valid_hash(mapsfromGoogleRoutes))
  end
def self.get_route_length(mapsfromGoogleRoutes)
  GooglePlacesHelper.getRouteLength( GetRestaurantListHelper.get_valid_hash(mapsfromGoogleRoutes) )
  end
end
