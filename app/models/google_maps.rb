include GoogleMapsHelper
require 'active_support'

class GoogleMaps < ActiveRecord::Base
   
  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  #Name:	get_direction_json
  #Description: Static method which is used to get a hash of JSONs.
  #		The JSONS are direction JSONs that will be sent back to
  #		the controller. We use helper methods to get the URL
  #		for a google maps call, call google maps to get a 
  #		response, check the status of our JSONs, check the
  #		existence of time and distance parameters, and retrieve
  #		additional jsons if those parameters exist. The purpose
  #		of the method is to retrieve directions depending the 
  #		params passed in by the user.
  #Params:	params - the hash of parameters passed in by the user which
  #			is sent to helper methods to do processes such
  #			as calling google maps API.
  #Return:	directions - a hash of direction JSONs. Each element of the
  #			hash is another JSON in hash form.
  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  def self.get_directions_json(params)
 
    # get our uri key from helper method get_uri
    url_key = get_url(params)
    # get our route JSON
    jsonRoute = get_json(url_key)
    
    # set our first directions json to be the :routes key.
    directions = {:routes => JSON.parse(jsonRoute)}

    # check the first json to see if the status was ok or not. If it is,
    # we do further checking on our parameters

    if(get_json_status(JSON.parse(jsonRoute) ) == ENV["MAPS_VALID_CODE"])

      # get keyCode determined by time/distance param
      keyCode = time_dist_check(params)
      
      # keyCode matching time param
      if(keyCode == 1)
        time = params[:time]
        time = time.to_f

        # since the time param exists, we get another json
        # by calling the get_json_time helper
        geoStop = get_json_time(jsonRoute,time)
        # now we put the new json into our :geoStop key
        directions[:geoStop] = JSON.parse(geoStop)
        
      # keyCode matching distance param
      elsif(keyCode == 2)
        distance = params[:distance]
        distance = distance.to_f
        
        #since the distance param exists, we get our distance
        #json and then put it into our :geoStop key.
        geoStop = get_json_distance(jsonRoute,distance)
        directions[:geoStop] = JSON.parse(geoStop)

      end 
 
    end
    # finally, we return the hash of jsons.
    return directions

  end

  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  #Name:	get_json_status
  #Description: Static method called by the controller and contains
  #		a single call to a helper method to retrieve the status
  #		of a route json. 
  #Params:	jsonRoute - the route json which will be sent in to
  #		the get_status helper to extract the status.
  #Return:	we return the return from get_status which is an int in
  #		range 100-107, 100 being the status representing success
  #		of a google maps api call.
  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 
  def self.get_json_status(jsonRoute)

    status = get_status(jsonRoute)

  end
    
  ##@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  #Name:	get_route_points
  #Description: static method that delegates the task of extracting
  #		route points from a route json to the get_points helper
  #		method. This static method is called from the controller
  #		to extract points.
  #Params:	jsonRoute- a json Route which will be passed into the 
  #			get_points to extract points.
  #Return:	points - the return from get_points, which is an array
  #			of arrays with each inner array containing
  #			a lat point in [0] and lng point in [1]
  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  def self.get_route_points(jsonRoute)

    points = get_points(jsonRoute)

  end


end
