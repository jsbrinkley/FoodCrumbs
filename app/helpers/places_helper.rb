require 'json'

# This module will be used by the places class to create the url that will be queried and
# to actually make that query and return a list of restaurants
module PlacesHelper

  # This function will build the url that will be used to make the places query
  def self.build_url(lat, long, radius, type, api_key)

    # The url template below will be used if a type is not specified
    if type.to_s == ""
      url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{lat},#{long}" + "&rankby=distance" + "&types=food" + "&sensor=false&key=#{api_key}"

    else  # The url template below will be used if a type is specified
      url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{lat},#{long}&rankby=distance&keyword=#{URI::encode(type)}+food&sensor=false&key=#{api_key}"
    end

    return url  # Return the constructed url
  end

  # This function will use the constructed url to make the request from google
  def self.query_url(url)
    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)

    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)

    response = http.request(request)

    foo = JSON.parse(response.body)
    foo.to_json
  end

end