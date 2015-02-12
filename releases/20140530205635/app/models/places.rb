class Places < ActiveRecord::Base
include PlacesHelper


def self.findPlaces lat, long, radius, type = ""
    url = PlacesHelper.build_url(lat, long, radius, type)
    response = PlacesHelper.query_url(url)
end

    def self.findPlaces lat, long, radius, type = ""
        url = PlacesHelper.build_url(lat, long, radius, type)
        response = PlacesHelper.query_url(url)
    end

end
