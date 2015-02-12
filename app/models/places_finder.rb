class PlacesFinder < ActiveRecord::Base

def self.getPlaces(maxRouteBoxer,userRouteBoxer,params)
    #queryList = resizeBoxesToCircles(maxRouteBoxer,searchString) # setup query
  searchString = ""
  if(defined? params[:places_filter])
searchString = params[:places_filter]
  end

#modifiedGoogleMaxRouteBoxer = truncate(maxRouteBoxer, 3)
    placesResults = placesQuery(userRouteBoxer, searchString)
  placesResults= filterResults(userRouteBoxer,placesResults)
    return JSON.generate(placesResults) 
end

#this function will cut off the first & last fraction (eg first and last 1/3
#of the routeBoxerArray)
def self.truncate(routeBoxerArray, fraction)
return routeBoxerArray.slice(1.0/fraction,(fraction-1.0)/fraction)
end

def self.placesQuery(maxRouteBoxer, searchString)
  radius = 5000
  midLat = (maxRouteBoxer[0][0][0]+maxRouteBoxer[0][1][0])/2.0
  #longitude for search
  midLong = (maxRouteBoxer[0][0][1]+maxRouteBoxer[0][1][1])/2.0


  placesList = JSON.parse(Places.findPlaces(midLat, midLong, radius, searchString))

  placesList.delete("html_attributions")
  placesList.delete("next_page_token")

  for i in 1..maxRouteBoxer.length-1
    #latitude for search
    midLat = (maxRouteBoxer[i][0][0]+maxRouteBoxer[i][1][0])/2.0
    #longitude for search
    midLong = (maxRouteBoxer[i][0][1]+maxRouteBoxer[i][1][1])/2.0


    placesListTemp = JSON.parse(Places.findPlaces(midLat, midLong, radius, searchString))
    placesList["results"].concat (placesListTemp)["results"]

  end

  placesList["results"] = placesList["results"].uniq # remove duplicates
  # placesList["results"] = placesList["results"].uniq # remove duplicates

  return placesList
end


def self.filterResults( userRouteBoxer, placesList )
    # filter for all restaurants if they're inside the user defined routeboxer
#bottomleft upperright
placesListNew = Array.new

    i = 0
    #loop through the list of places
    while i < placesList["results"].length
        #we assume it is not in bounds
        inBounds = false 

        #itterate through the user defined boxes
        for j in 0..(userRouteBoxer.length-1)

          placesList_lat= placesList["results"][i]["geometry"]["location"]["lat"]
          placesList_long=placesList["results"][i]["geometry"]["location"]["lng"]
          #get the lat and long of the current place
          #if it is in  bounds
routeBoxerTopRightLat = userRouteBoxer[j][1][0]
routeBoxerTopRightLong = userRouteBoxer[j][1][1]
routeBoxerBotLeftLat = userRouteBoxer[j][0][0]
routeBoxerBotLeftLong = userRouteBoxer[j][0][1]

            if( placesList_lat > routeBoxerBotLeftLat &&
                placesList_lat <  routeBoxerTopRightLat &&
                placesList_long > routeBoxerBotLeftLong &&
                placesList_long < routeBoxerTopRightLong)
              inBounds = true
              break
            end
        end
        #if it is not in bounds
        if inBounds == true 
            placesListNew.push(placesList["results"][i])
        end
         i = i + 1
    end

placesList.store("results",placesListNew)

    return placesList

end
  end
