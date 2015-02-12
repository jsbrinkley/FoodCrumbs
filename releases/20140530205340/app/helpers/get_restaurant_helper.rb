module GetRestaurantHelper

  # Returns the full title on a per-page basis.
  def @self.get_restaurant_json_hasher(json1, json2)
    #get our 2 array of results
    mrg = JSON.parse(json1)['results']
    results2 = JSON.parse(json2)['results']
    #currently nonoptimal code because I have no idea how to implement a hash table in Ruby
    mrg.reverse_merge!(defaults)
    return mrg
  end



end
