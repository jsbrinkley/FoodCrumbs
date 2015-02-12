require 'google_places'
require 'json'
class DetailsController < ApplicationController
  def index

    detailsJSON = Details.getDetails(params[:reference])
    render json: detailsJSON
=begin
    detailsJSON = Details.getDetails("CoQBeQAAAI_kB4N-5yXoG6qKuQEcZF-zX5NFA5XVDcXYgM4wcEkduYsHHJVPdui4RAWVJV3n-qrL10bdBS4deWVEVg0U6pugKBAjLiE8u4ZEhHAFZE8p4st5ZEfQmaGj1DL6LBlaWOd1WIZCUKMn1VTUvNter3kDywkXxEH443kpNKQsKcU-EhD6u5TB89BjbTVQqLq4N4FzGhSg9d_2BvAbPWt4rBx9x0nj_ILkng")
    puts(detailsJSON)
    
=begin
        #@query = Places.find( 33.742006, -117.843843 )
        @client = GooglePlaces::Client.new('AIzaSyBdfbDfA6R0H0e3gDPXHNIW4cNJJAEjSss')
        @query = @client.spots_by_query('Horchatas near UCSD', :radius => 100)
        @query.each do |x|
           @details = Details.getDetails(x.reference)
           break
        end
        return @details
=end

  end
end
