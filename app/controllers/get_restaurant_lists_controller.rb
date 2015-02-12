require 'net/http'
require 'rubygems'
require 'json'
require 'active_support'
require 'yaml'


class GetRestaurantListsController < ApplicationController
  include GetRestaurantListHelper
  include GoogleMapsHelper
  helper_method :all

  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  #Name:	index
  #Description: This is where all the url requests go to. This function
  # will process the parameter requests. If there is an error at any step
  # the program will terminate and return whatever data up until that point
  # is valid. It will also notify the user.
  #Params:	params - A map of all the parameters the user will pass in
  # these include an array of geolocation points, a radius,and a time or
  # distance into the route to stop
  #Return:	jsonStr - the JSON representation of the result (the route,
  # the point of x time/distance into the route, and all the places it
  # finds along the route)
  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  def index

    #1. Get the JSON Hash

    mapsfromGoogleRoutes= GetRestaurantList.get_google_maps(params)

    jsonStr = GetRestaurantList.generate_json_maps(mapsfromGoogleRoutes)
    if (GetRestaurantList.get_status_of_map(mapsfromGoogleRoutes) != ENV["MAPS_VALID_CODE"])
      render json:jsonStr
      return
    end

    arrayOfRouteLocations = GetRestaurantList.get_array_points_for_boxer(mapsfromGoogleRoutes)


    #2. Push the stuff to routeBoxer.
    # arg1 should be an array of coordinate. arg2 should be the radius

    #convert the miles into kilometers

    defaultParameter = 4
    if (params.has_key? (:radius))
      defaultParameter = params[:radius].to_f*1.6
    end
    jsonArrayofUserDefinedRouteBoxes = RouteBoxerHelper.get_route_boxes(arrayOfRouteLocations, defaultParameter)

    #boxer has these as a json. We're going to convert these to an array of array of array of floats
    arrayofUserDefinedRouteBoxes = RouteBoxerHelper.convert_route_boxes_json_to_array(jsonArrayofUserDefinedRouteBoxes)

    #get it as google max
    jsonArrayofGoogleMaxRouteBoxes = RouteBoxerHelper.get_route_boxes(arrayOfRouteLocations,10)

    #boxer has these as a json. We're going to convert these to an array of array of array of floats
    arrayofGoogleMaxRouteBoxes = RouteBoxerHelper.convert_route_boxes_json_to_array(jsonArrayofGoogleMaxRouteBoxes)


    places = PlacesFinder.getPlaces(arrayofGoogleMaxRouteBoxes, arrayofUserDefinedRouteBoxes, params)


    jsonPlaces = {:places => ActiveSupport::JSON.decode(places)}
    jsonStr = jsonStr.merge(jsonPlaces)

    render json:jsonStr

  end


end
