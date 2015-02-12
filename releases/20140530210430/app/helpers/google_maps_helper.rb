module GoogleMapsHelper

  # helper method to retrieve our uri string
  def get_url(params)

    origin = ""
    destination = ""

    if(params[:origin] != nil)
      origin = params[:origin]
    end

    if(params[:destination] != nil)
      destination = params[:destination]
    else
      destination = origin
    end

    url = "https://maps.googleapis.com/maps/api/directions/" +
          "json?sensor=false&origin=" + origin +
          "&destination=" + destination + "&key="+ENV["GOOGLE_API_KEY"]

    url = url.gsub(' ','_')
  end

  # GET_JSON method to retrieve json from our google
  # directions api
  def get_json(url_param)

    uri = URI(url_param)
    http = Net::HTTP.new(uri.host, uri.port)

    # enable ssl on our http request, then verify before
    # using our get call 
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri.request_uri)

    responseRoute = http.request(request)

    # this returns a rendered json from the body of our 
    # http request 
    jsonRoute = ActiveSupport::JSON.decode(responseRoute.body)
    jsonRoute.to_json
  end

  # will parse the string and retrieve the "status"
  def get_status(jsonRoute)

    jsonRoute = JSON.parse(jsonRoute)
    # get our "status" key from the hash
    status = jsonRoute["status"]


    # determine what ERROR code to return depending on the status
    if(status == ENV["MAPS_VALID"])
      return ENV["MAPS_VALID_CODE"]
    end
    if( status== "NOT_FOUND")
      return 101
    end
    if( status=="ZERO_RESULTS")
      return 102
    end
    if(status=="MAX_WAYPOINTS_EXCEEDED")
      return 103
    end
    if(status =="INVALID_REQUEST")
      return 104
    end
    if(status =="OVER_QUERY_LIMIT")
      return 105
    end
    if(status =="REQUEST_DENIED")
      return 106
    end

    #unknown erro return  
    return 107
  end

  # shall get points of each route 
  def get_points(jsonRoute)

    jsonRoute = JSON.parse(jsonRoute)

    # array to hold our our collection of points
    arrayOfCoordinates = Array.new()


    lat = jsonRoute['routes'][0]['legs'][0]['start_location']['lat']
    lng = jsonRoute['routes'][0]['legs'][0]['start_location']['lng']

    firstPoint = Array.new()
    firstPoint.push(lat)
    firstPoint.push(lng)

    arrayOfCoordinates.push(firstPoint)

    steps = jsonRoute['routes'][0]['legs'][0]['steps']

    # go through each step
    steps.each do |step|

      # each step, get lat. & lng. location and push 
      lat = step["end_location"]["lat"]
      lng = step["end_location"]["lng"]

      endCoordinates = Array.new()
      endCoordinates.push(lat)
      endCoordinates.push(lng)

      arrayOfCoordinates.push(endCoordinates)

    end

    return arrayOfCoordinates

  end



  def self.get_status(json)
    GoogleMap.get_json_status(json)
  end

  def self.get_route_from_google_maps_json(routeOfTripJson)
    #should check but it is supposed to be already parsed coming in
    #check to see if this is a google maps valid json
    #1) Check if the string is formated ok as a JSON
    #2) Check if the status is ok

    #3) Extract the steps/legs portion of the json
    stepsOfRoute = get_routes(routeOfTripJson)

#extract the boxes, if possible
    arrayOfCoordinates = Array.new()

    stepsOfRoute.each do |item|
      #Rails.logger.info item['start_location']
      starting_coordinate = item['start_location']
      lat = starting_coordinate['lat']
      lng = starting_coordinate['lng']

      coordinates = Array.new()
      coordinates.push(lat)
      coordinates.push(lng)

      arrayOfCoordinates.push(coordinates)

    end
    return arrayOfCoordinates
  end

end
