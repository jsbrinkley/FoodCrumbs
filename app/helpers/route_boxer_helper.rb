require 'php'
require 'json'
module RouteBoxerHelper

  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  #Name:	get_route_boxes
  #Description: This function will execute the getBoxes script that is
  # written in php.
  #Params:	arrayOfRouteLocations - an array of array of geolocation points
  # arranged in latitude and longitude of a google route
  # radius - a float of how far away the user wants to deviate
  #Return:	arrayOfBoxesJSON - a json array of routeboxer points
  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  def self.get_route_boxes(arrayOfRouteLocations, radius)
    #check to make sure array of Boxes is ok

    #check to make sure radius is numeric. If it isn't valid, we input our own defualt
    #screw that let google handle it
    valid_radius = 10

    if radius != nil
    if(numeric?(radius))
      valid_radius = radius
    end
    end


arrayOfRouteLocationsJSON = arrayOfRouteLocations.to_json
  arrayOfBoxesJSON = `php app/assets/php/src/getBoxes.php #{arrayOfRouteLocationsJSON} #{valid_radius}`
    return arrayOfBoxesJSON

    end



  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  #Name:	convert_route_boxes_json_to_array
  #Description: This function will convert the output of get_route_bxes
  # into a json representation
  #Params:	jsonArrayRouteBoxesRawString - an array of array of routeboxer
  # locations.
  #Return:	arrayOfBoxCoordinates - a json representation of routeboxer points
  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
def self.convert_route_boxes_json_to_array(jsonArrayRouteBoxesRawString)
#check to see if this is a google maps valid json
#1) Check if the string is formated ok as a JSON
#2) Check if the status is ok

#3) Extract the steps/legs portion of the json
    stepsOfRoute = get_routes(jsonArrayRouteBoxesRawString)


#extract the boxes, if possible
    arrayOfBoxCoordinates = Array.new()

    stepsOfRoute.each do |item|
      starting_coordinate = item['upper-right']
      lat = starting_coordinate['latitude']
      lng = starting_coordinate['longitude']

      upperRight = Array.new()
      upperRight.push(lat)
      upperRight.push(lng)

      starting_coordinate = item['bottom-left']
      lat = starting_coordinate['latitude']
      lng = starting_coordinate['longitude']

      bottomLeft= Array.new()
      bottomLeft.push(lat)
      bottomLeft.push(lng)

      boxCoordinates = Array.new()


      boxCoordinates.push(bottomLeft)
      boxCoordinates.push(upperRight)
      arrayOfBoxCoordinates.push(boxCoordinates)
    end
    return arrayOfBoxCoordinates

  end
  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  #Name:	get_route_boxes_array
  #Description: This function will execute the getBoxes script that is
  # written in php and return the array representation
  #Params:	arrayOfRouteLocations - an array of array of geolocation points
  # arranged in latitude and longitude of a google route
  # radius - a float of how far away the user wants to deviate
  #Return:	arrayOfBoxCoordinatesUser - a  representation of routeboxer points
  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  def self.get_route_boxes_array(arrayOfRouteLocations, radius)
    jsonArrayofUserDefinedRouteBoxes = RouteBoxerHelper.get_route_boxes(arrayOfRouteLocations, radius)

    #boxer has these as a json. We're going to convert these to an array of array of array of floats
    arrayOfBoxCoordinatesUser = RouteBoxerHelper.convert_route_boxes_json_to_array(jsonArrayofUserDefinedRouteBoxes)

    return arrayOfBoxCoordinatesUser
  end
  
  def self.numeric?(object)
      true if Float(object) rescue false
  end
 def self.get_routes(googleMapsJson)
    #check if it is a json

    #extract if it is relevant
    routes = JSON.parse(googleMapsJson)['boxes']

    #return. Must note what happens on failure.
    return routes

  end
end
