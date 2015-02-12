# The purpose of this class is to return a list of restaurants that are
# closest to the location specified
class Places < ActiveRecord::Base
  include PlacesHelper

  # This function is used to find the restaurant results by
  # querying google
  def self.findPlaces lat, long, radius, type = ""

    # The following case statement will select a random API key
    # because we are only allowed to make 1000 queries per key
    # a day, by randomly selecting from several keys we are
    # able to make several thousand queries
    a = rand(6)
    case a
      when 0
        api_key = 'AIzaSyAAe8uFG4L8f_LYe-7etsNwdXraAUxIcPs'
      when 1
        api_key = 'AIzaSyAAe8uFG4L8f_LYe-7etsNwdXraAUxIcPs'
      when 2
        api_key = 'AIzaSyAAe8uFG4L8f_LYe-7etsNwdXraAUxIcPs'
      when 3
        api_key = 'AIzaSyAAe8uFG4L8f_LYe-7etsNwdXraAUxIcPs'
      when 4
        api_key = 'AIzaSyAAe8uFG4L8f_LYe-7etsNwdXraAUxIcPs'
      when 5
        api_key = 'AIzaSyAAe8uFG4L8f_LYe-7etsNwdXraAUxIcPs'
    end

    # Call build url to create the URL that will attain our
    # restaurant results
    url = PlacesHelper.build_url(lat, long, radius, type, api_key)
puts(url)
    # Get the json representation of the results from google
    # this json will contain up to 20 restaurants
    response = PlacesHelper.query_url(url)
  end

end
