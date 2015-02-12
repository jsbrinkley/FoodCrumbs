module DetailsHelper

   def self.build_url(ref)
       url =  "https://maps.googleapis.com/maps/api/place/details/json?reference=#{ref}" + "&sensor=false" + "&key=AIzaSyBdfbDfA6R0H0e3gDPXHNIW4cNJJAEjSss"
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

end
