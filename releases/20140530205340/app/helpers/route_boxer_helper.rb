require 'php'
require 'json'
module RouteBoxerHelper

  # Returns the full title on a per-page basis.
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

    def self.numeric?(object)
      true if Float(object) rescue false
    end

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

  def self.get_routes(googleMapsJson)
    #check if it is a json

    #extract if it is relevant
    routes = JSON.parse(googleMapsJson)['boxes']

    #return. Must note what happens on failure.
    return routes

  end
private
    def self.checkValidInputs(arrayOfRouteLocations, radius)
      render json: { errors: @model.errors }
    end
end
