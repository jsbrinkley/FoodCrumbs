#include GetRestaurantListHelper
require 'net/http'
require 'rubygems'
require 'json'
require 'active_support'
require 'yaml'


class GetRestaurantListsController < ApplicationController
  include GetRestaurantListHelper
  include JsonHelper
  include GoogleMapsHelper

#helper:all
#need the filter
  helper_method :all
#Check if the parameters exist before we do ANYTHING

# GET /get_restaurant_lists
# GET /get_restaurant_lists.json

  def index

    #1. Get the JSON Hash
    mapsJSON = GetRestaurantList.get_google_maps(params)

    #check if it is valid
    jsonStr = {:routes => ActiveSupport::JSON.decode(mapsJSON)}



      if(GoogleMapsHelper.get_status(mapsJSON) !=  ENV["MAPS_VALID_CODE"])
    render json: jsonStr
     return
      end


    #now we have a json array. we want to extract all the start_locations from them
    #extract the points along the route

   arrayOfRouteLocations = GoogleMapsHelper.get_points(mapsJSON)


    #2. Push the stuff to routeBoxer.
    # arg1 should be an array of coordinate. arg2 should be the radius

    jsonArrayofUserDefinedRouteBoxes = RouteBoxerHelper.get_route_boxes(arrayOfRouteLocations, params[:radius])

    #boxer has these as a json. We're going to convert these to an array of array of array of floats
    arrayOfBoxCoordinatesUser = RouteBoxerHelper.convert_route_boxes_json_to_array(jsonArrayofUserDefinedRouteBoxes)

    #get it as google max
    jsonArrayofGoogleMaxRouteBoxes = RouteBoxerHelper.get_route_boxes(arrayOfRouteLocations,50)

    #boxer has these as a json. We're going to convert these to an array of array of array of floats
    arrayOfBoxCoordinatesGoogleMax = RouteBoxerHelper.convert_route_boxes_json_to_array(jsonArrayofGoogleMaxRouteBoxes)
=begin
    #3. Algoirthm
arrayOfBoxCoordinates = RouteBoxerHelper.get_route_boxes("foo", 5)
  for i in 0...boxesArray.size
         placeResponse = GetRestaurantList.get_restaurant_along_route(arrayOfBoxCoordinates[i])
       hashOfPlacesJsonResponse = GetRestaurantHelper.get_restaurant_json_hasher(hashOfPlacesJsonResponse, placeResponse)
    end

=end
#need to parse
   #p arrayOfBoxCoordinatesUser;
places = PlacesFinder.getPlaces(arrayOfBoxCoordinatesGoogleMax,arrayOfBoxCoordinatesUser,params[:term])
    jsonPlaces = {:places => ActiveSupport::JSON.decode(places)}
    jsonStr = jsonStr.merge(jsonPlaces)

render json:jsonStr
  end


# GET /get_restaurant_lists/1
# GET /get_restaurant_lists/1.json
  def show
    @get_restaurant_list = GetRestaurantList.find(params[:id])

    render json: @get_restaurant_list
  end

  # POST /get_restaurant_lists
  # POST /get_restaurant_lists.json
  def create
    @get_restaurant_list = GetRestaurantList.new(params[:get_restaurant_list])

    if @get_restaurant_list.save
      render json: @get_restaurant_list, status: :created, location: @get_restaurant_list
    else
      render json: @get_restaurant_list.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /get_restaurant_lists/1
  # PATCH/PUT /get_restaurant_lists/1.json
  def update
    @get_restaurant_list = GetRestaurantList.find(params[:id])

    if @get_restaurant_list.update(params[:get_restaurant_list])
      head :no_content
    else
      render json: @get_restaurant_list.errors, status: :unprocessable_entity
    end
  end

  # DELETE /get_restaurant_lists/1
  # DELETE /get_restaurant_lists/1.json
  def destroy
    @get_restaurant_list = GetRestaurantList.find(params[:id])
    @get_restaurant_list.destroy

    head :no_content
  end

end
