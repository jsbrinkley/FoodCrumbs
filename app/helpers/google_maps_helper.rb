module GoogleMapsHelper


  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  #Name:	get_url
  #Description: This helper method is used to construct a string that will
  #		be used as a URL to call the google Maps API. Our string
  #		will contain an origin, destination, and a API Key. Once
  #		the URL string is constructed using concatenation, the
  #		string is returned.
  #Params:	params - the hash of parameters sent in by the server user
  #Return:	url - the string which represents a url to call google
  #			maps.
  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

  def get_url(parama)

    # set our params to variables, this makes sure we have variables set
    # incase the app sent in empty string params
    origin = parama[:origin]
    destination = parama[:destination]

    # handle nil checks incase the Application dev. does not call our app
    # correctly 
    if(origin == nil && destination == nil)
        origin = ""
        destination = ""
    elsif(origin == nil && destination != nil)
        origin = ""
    elsif(origin != nil && destination == nil)
        destination = ""
    end

    # following checks will handle the case when the app wants to do a single
    # location check
    if(origin.length == 0 && destination.length != 0)
        origin = destination
    elsif(origin.length!= 0 && destination.length == 0)
        destination = origin
    end
    
    # constructs the string using our origin, dest, & API key
    url = "https://maps.googleapis.com/maps/api/directions/" +
          "json?sensor=false&origin=" + origin +
          "&destination=" + destination + "&key="+ENV["GOOGLE_API_KEY"]

    # substitute the spaces in our string with underscores
    url = url.gsub(' ','_')

  end

  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  #Name:	get_json
  #Description: This method uses the HTTP & Net to do HTTP requests to 
  #		the google maps API. First, we use the url_param which is
  # 		our constructed URL, after we call URI, we can get a HTTP
  #		Request and get our response. The response is a JSON which
  #		is then decoded into a hash to extract data from later on.
  #Params:	url_param - a string which represents a google maps URL 
  #			call.
  #Return:	jsonRoute - a hash which was retrieved by decoding a 
  #			json returned from our HTTP request.
  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  def get_json(url_param)

    # get the uri from using a URI method that will be used to get a new
    # HTTP request
    uri = URI(url_param)
    http = Net::HTTP.new(uri.host, uri.port)

    # enable ssl on our http request, then verify before
    # using our get call 
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    # receive the new secure HTTP 
    request = Net::HTTP::Get.new(uri.request_uri)


    # call the request method to get our response from the Request

    responseRoute = http.request(request)

    # this returns a rendered json from the body of our 
    # http request 
    jsonRoute = ActiveSupport::JSON.decode(responseRoute.body)
    jsonRoute.to_json

  end

  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  #Name:	get_status
  #Description: This method receives a hash and accesses the hash's 
  #		status key. Depending on what the value of the key is, we
  #		return a certain CODE so the user knows what the error was
  #		with our previous HTTP request or if it went through OK.
  #Params:	jsonRoute - the hash representing our return from google
  #			maps.
  #Return:	int - 100/ENV["MAPS_VALID_CODE"] - the call went through
  #			and was a success.
  #		int - 101-107 - the call went through but failed.
  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  def get_status(jsonRoute)


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

    #unknown error return  

    return 107
  end

  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  #Name:	get_points
  #Description: This method receives the route Hash and extracts the
  #		very first lat & lng points of our route and then extracts
  #		all following end points for each step of the route.
  #		These points are stored in an array, and each array of 
  #		points is stored into another array to be sent back to
  #		the controller.
  #Params:	jsonRoute - the route Hash retrieved from google maps
  #Return:	arrayOfCoordinates - an Array of arrays. Each element
  #			array contains a lat in [0] index and lat in [1]
  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  def get_points(jsonRoute)

    # array to hold our our collection of points
    arrayOfCoordinates = Array.new()
   

    # extract the first lat & lng points of our route

    lat = jsonRoute['routes'][0]['legs'][0]['start_location']['lat']
    lng = jsonRoute['routes'][0]['legs'][0]['start_location']['lng']

    # we now push our lat,lng into an array
    firstPoint = Array.new()
    firstPoint.push(lat)
    firstPoint.push(lng)

    # put our first arrray into the collection

    arrayOfCoordinates.push(firstPoint)
   
    # retrieve our list of steps from the route hash
    steps = jsonRoute['routes'][0]['legs'][0]['steps']

    # go through each step
    steps.each do |step|

      
      # each step, get lat. & lng. location and push 
      lat = step["end_location"]["lat"]
      lng = step["end_location"]["lng"]
      
      endCoordinates = Array.new()
      endCoordinates.push(lat)
      endCoordinates.push(lng)
  
      # now we push each array into our collection
      arrayOfCoordinates.push(endCoordinates)
      
    end
    #Finally we return our collection of coordinates
    return arrayOfCoordinates

  end

  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  #Name:	time_convert
  #Description: This converts a string of similar format to 
  #		"value Day value Hour value Min", to an equivalent
  #		number of hours as a float.
  #Params: timeString - the time formatted string which we convert to 
  #		a value of hours.
  #Return: hour - a float which is the converted value of hours from the
  #		timeString.
  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  def time_convert(timeString)

    # initialize our variables to 0.
    day=0
    hour=0
    min=0
    
    # first we split our string by its spaces and change it to
    # an array.
    array = timeString.split(' ')
    array = array.to_a

    # when there is only 1 field, check what type it is (Day/Hour/Min)
    # and handle the assignment depending on the string include method
    if(array.length == 2)

      if(array[1].include?"day")
        day = array[0].to_f
      elsif(array[1].include?"hour")
        hour = array[0].to_f
      else
        min = array[0].to_f
      end

    # for 2 fields, we again check which types are in the string and
    # assign certain elements within the array to our variables. 
    elsif(array.length == 4)
      if(array[1].include?"day")
        day = array[0].to_f

        if(array[3].include"hour")
          hour = array[2].to_f
        else
          min = array[2].to_f
        end
      else
        hour = array[0].to_f
        min = array[2].to_f

    # 3 fields, we know where there is a Day/Hour/Min and can
    # easily assign indices of the array to our variables 
      end
      day = array[0].to_f
      hour = array[2].to_f
      min = array[4].to_f

    end
   
    # convert our variables into hours and then return the 
    # hour variable
    hour = (day*24) + hour + (min/60)

    return hour

  end
 
  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  #Name:	mile_convert
  #Description: Converts a string of format "value miles" into a float
  #		value of the miles within the string.
  #Params:	mileString the string which will be converted to a float
  #		value.
  #Return:	miles - the number of miles parsed from the string.
  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  def mile_convert(mileString)
    # first we split the string into an array
    array = mileString.split(' ')
    # get rid of the comma, incase the value is in the thousands place
    miles = array[0].delete(',')
    # now we convert that string to a float
    miles = miles.to_f
    
    # if the [1] index contained ft, we convert the feet value to miles
    if(array[1] == "ft")
      miles = (miles/5280)
    end

    return miles
  end


  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  #Name:	get_json_time
  #Description: This method goes through the route hash and uses a
  #		float to determine at which step in the route, is our 
  #		time parameter exceeding the time elapsed on the route.
  #		Once that point is reached, we extract the lat, and lng
  #		of our last step's end_location and use those points
  #		to do another google maps call.
  #Params:	jsonRoute - the route hash which is used to extract
  #			the elapsed time of the trip and lat,lng points.
  #		time - a float valued used to determine how long int the
  #			the trip the user wants to go.
  #Return:	# we return a new hash which was constructed by passing
  #               in a newly formed URL into our get_json helper method.
  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  def get_json_time(jsonRoute, time)
   
    #Parse our json to access keys within it 
    jsonRoute = JSON.parse(jsonRoute)
    #initiallly set param keys to be empty strings
    params = {:origin => "", :destination => ""}

    # get the max time it'll take to go through the trip
    maxTime = jsonRoute['routes'][0]['legs'][0]['duration']['text']
    maxTime = time_convert(maxTime)
   
    # if the max time is less than the time passed in, we just extract
    # the last point of the trip and set those points equal to the
    # origin
    if(time > maxTime)
    
      lat = jsonRoute['routes'][0]['legs'][0]['end_location']['lat']
      lng = jsonRoute['routes'][0]['legs'][0]['end_location']['lng']
      origin = "#{lat},#{lng}"
      
    else
      
      # set our time counter to 0
      timeCount = 0
      # retrieve the list of steps in our trip
      steps = jsonRoute['routes'][0]['legs'][0]['steps']
      
      # now for each step, increment our timeCount by the
      # duration of each step, and set our lat and lng points
      # to be the points of the end location in that step
      steps.each do |step|
        
        stepTime = step['duration']['text']
        timeCount = timeCount + time_convert(stepTime)

        lat = step["end_location"]["lat"]
        lng = step["end_location"]["lng"]
        
        # we break once our timeCount exceeds our time param
        break if timeCount > time

      end
      # now we assign origin to be the latest lat,lng points
      origin = "#{lat},#{lng}"
 
    end
     
    # assign our origin in params to be the origin constructed by our
    # lat and lng points
    params[:origin] = origin
    
    # we get our URL from get_url helper and then get the
    # json from get_json helper and return the 
    # json.
    url = get_url(params)
    json = get_json(url)
    
    return json
 
  end

  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  #Name:	get_json_distance
  #Description: This method goes through the route hash and uses a
  #		float to determine at which step in the route, is our 
  #		distance parameter exceeding the distance traveled on the route.
  #		Once that point is reached, we extract the lat, and lng
  #		of our last step's end_location and use those points
  #		to do another google maps call.
  #Params:	jsonRoute - the route hash which is used to extract
  #			the traveled dist. of the trip and lat,lng points.
  #		ditance - a float valued used to determine how far in the
  #			the trip the user wants to go.
  #Return:	# we return a new hash which was constructed by passing
  #               in a newly formed URL into our get_json helper method.
  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  def get_json_distance(jsonRoute, distance)
    # parse the json to extract certain keys from it.
    jsonRoute = JSON.parse(jsonRoute)
    params = {:origin=>"", :destination=>""}
    
    # retrieve the max distance of the whole trip
    maxDist = jsonRoute['routes'][0]['legs'][0]['distance']['text']
    maxDist = mile_convert(maxDist)

    # if our distance exceedsd the max distance, we just extract
    # the end_location of our leg and set those points equal to our
    # origin
    if(distance > maxDist)
   
      lat = jsonRoute['routes'][0]['legs'][0]['end_location']['lat']
      lng = jsonRoute['routes'][0]['legs'][0]['end_location']['lng']
      origin = "#{lat},#{lng}"
    else
      # use a mileCounter to keep track of distance traveled
      milesCount = 0
      # we now retrieve the list of steps in our trip
      steps = jsonRoute['routes'][0]['legs'][0]['steps']
      
      # we go through each step and increment our milesCounter
      # by the distance traveled in that step. Extract
      # the end location's points and do this for 
      # each step until our miles counter exceeds the
      # distance passed in by the user
      steps.each do |step|
        
        stepDist = step['distance']['text']
        milesCount = milesCount + mile_convert(stepDist)

        lat = step["end_location"]["lat"]
        lng = step["end_location"]["lng"]
        
        break if milesCount > distance

      end
      
      origin = "#{lat},#{lng}"
      
    end
  
    # set the params origin to be the origin of lat,lng points we 
    # extracted
    params[:origin] = origin

    # now call the get_url helper and get_json helpers to retrieve
    # a new json from the google maps API.
    url = get_url(params)
    json = get_json(url)

    return json

  end
 
  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  #Name:	time_dist_check
  #Description: This method checks to see if our time or distance params
  #		exist. If neither exist, we return 0, but if either exist
  #		we return a number which is checked back in the module to
  #		determine which get_json helper is called.
  #Params:	params - the parameter hash passed in by the user.
  #Return:	1 - returned when the time param exists
  #		2 - returned when the distance param exists
  #		0 - returned when neither time nor distance exists.
  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  def time_dist_check(params)
    # retrieve time & distance from the params
    time = params[:time]
    distance = params[:distance]

    # handle nil checks in case the Application dev. does not call our app
    # correctly 
    if(time == nil)
       time = ""
    end
    if(distance == nil)
       distance=""
    end
  
    # return value to determine which checker to call back in module
    if(time.length != 0)
       return 1;
    elsif(distance.length != 0)
       return 2;
    else
       return 0;
    end

  end

  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  #Name:	get_direction
  #Description: returns the element of the routes key within a hash.
  #Params:	jsonHash - a Hash which is passed in to retrieve  
  #		a routes key. 
  #Return:	nil - if the :routes key does not exist 
  #		A HASH - if the :routes key contains something
  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  def get_direction(jsonHash)
    return jsonHash[:routes]
  end

  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  #Name:	get_geostop
  #Description:	returns the element of the geostop key within a hash.
  #Params:	jsonHash - a Hash which is passed in to retrieve a geostop
  #			key.
  #Return:	nil - if the :geoStop key does not exist
  #		A HASH - if the :geoStop key contains something
  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  def get_geostop(jsonHash)
    return jsonHash[:geoStop]
  end

end
