require 'google_places'
class PlacesController < ApplicationController
  API_KEY = 'AIzaSyBdfbDfA6R0H0e3gDPXHNIW4cNJJAEjSss'
  def index
 
    Places.findPlaces(32.880578,-117.234832, 150 )
    Places.findPlaces(32.880506,-117.234832, 50, "mexican")
    #first register client
    #@places = PlacesController.query( 33.742006, -117.843843, 1000, "Mexican")
=begin   
    @spotList = @client.spots('33.12312', 151.1957362, :types => ['restaurant','food'])

    # search by a radius (in meters)
     #@radiusList = render :json => @client.spots( -33.8670522, 151.1957362, :radius => 100)

    lat,long = Places.passCoordinates( 33.742006, -117.843843 )
    @query = render :json => @client.spots( lat, long, :radius => 1000)
    query = render :json => @client.spots_by_query('Horchatas near UCSD', :radius => 100)
    puts (query)
    @query = render :json => @query
    foo = Places.getPlaces( 33.742006, -117.843843, 1000, "Mexican" )
    puts ("____________________________________")
    render :json => foo
    foo.each do |x|
      puts(x)
    end

=end
    # search based on query
    #@query = @client.spots_by_query('Horchatas near UCSD', :radius => 100)
    #@query = @client.spots_by_query('Quick bite near tustin, CA', :types => 'food', :radius => 1000)
  end

end
