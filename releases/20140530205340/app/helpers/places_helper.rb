require 'json'
module PlacesHelper
    API_KEY = 'AIzaSyBdfbDfA6R0H0e3gDPXHNIW4cNJJAEjSss'

    def self.build_url(lat, long, radius, type )
        if type == ""
            url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{lat},#{long}" + "&radius=#{radius}" + "&types=restaurant" + "&sensor=false&key=#{API_KEY}"
        else
            url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{lat},#{long}&radius=#{radius}&keyword=#{type}+food&sensor=false&key=#{API_KEY}"
        end
        return url
    end

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
=begin
@client = GooglePlaces::Client.new( API_KEY )

def self.query(lat, long, radius, type)
if type == ""
return @client.spots( lat, long, radius: radius )
else
return @client.spots( lat, long, types: type, radius: radius )

end
end
=end

end
