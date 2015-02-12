require 'test/unit'

class DetailsTest < Test::Unit::TestCase
  def test_for_json
    testOutput = Details.getDetails("CoQBegAAAH5bGFdFfdjzL6tX34pEv4c8uGpz4ds7hxmahShPmblpnreCq2PiI0lanmqmj7uh9_0QQ3mBnE36tfyrJ0kOA_YNbEoAD7GgMUaiftsud9kd0GTHo1Jf2gmTVqILQrviTBgZM-ywWXPnPgFkkIxVA86zuD3LVWb4LRKl2vRpfKgvEhBONIyKCuVUZOdHe01j8LZKGhTFB1FPCtYEajppcdeqcmrN6cXWWw")
    testOutput = JSON.parse(testOutput)
    assert testOutput["result"]["name"] == "Zanzibar Cafe At the Loft",testOutput["result"]["name"]
  end
  def test_for_equality
     testOutput = Details.getDetails("CoQBegAAAH5bGFdFfdjzL6tX34pEv4c8uGpz4ds7hxmahShPmblpnreCq2PiI0lanmqmj7uh9_0QQ3mBnE36tfyrJ0kOA_YNbEoAD7GgMUaiftsud9kd0GTHo1Jf2gmTVqILQrviTBgZM-ywWXPnPgFkkIxVA86zuD3LVWb4LRKl2vRpfKgvEhBONIyKCuVUZOdHe01j8LZKGhTFB1FPCtYEajppcdeqcmrN6cXWWw")
     expectedOutput =  {"html_attributions"=>[], "result"=>{"address_components"=>[{"long_name"=>"9500", "short_name"=>"9500", "types"=>["street_number"]}, {"long_name"=>"Gilman Dr", "short_name"=>"Gilman Dr", "types"=>["route"]}, {"long_name"=>"La Jolla", "short_name"=>"La Jolla", "types"=>["sublocality", "political"]}, {"long_name"=>"CA", "short_name"=>"CA", "types"=>["administrative_area_level_1", "political"]}, {"long_name"=>"United States", "short_name"=>"US", "types"=>["country", "political"]}, {"long_name"=>"92093", "short_name"=>"92093", "types"=>["postal_code"]}, {"long_name"=>"5004", "short_name"=>"5004", "types"=>[]}], "adr_address"=>"<span class=\"street-address\">9500 Gilman Dr</span>, <span class=\"locality\">La Jolla</span>, <span class=\"region\">CA</span> <span class=\"postal-code\">92093</span>, <span class=\"country-name\">United States</span>", "formatted_address"=>"9500 Gilman Dr, La Jolla, CA, United States", "formatted_phone_number"=>"(858) 678-0922", "geometry"=>{"location"=>{"lat"=>32.87947, "lng"=>-117.236017}}, "icon"=>"http://maps.gstatic.com/mapfiles/place_api/icons/cafe-71.png", "id"=>"93ee0a8c60a10ce572275e8da588deff52a11a53", "international_phone_number"=>"+1 858-678-0922", "name"=>"Zanzibar Cafe At the Loft", "opening_hours"=>{"open_now"=>false, "periods"=>[{"close"=>{"day"=>1, "time"=>"1600"}, "open"=>{"day"=>1, "time"=>"0830"}}, {"close"=>{"day"=>2, "time"=>"1600"}, "open"=>{"day"=>2, "time"=>"0830"}}, {"close"=>{"day"=>3, "time"=>"1600"}, "open"=>{"day"=>3, "time"=>"0830"}}, {"close"=>{"day"=>4, "time"=>"1600"}, "open"=>{"day"=>4, "time"=>"0830"}}, {"close"=>{"day"=>5, "time"=>"1600"}, "open"=>{"day"=>5, "time"=>"0830"}}]}, "rating"=>3.6, "reference"=>"CoQBegAAAPUD2hwk9EdgUMZSZZXXcLedjYAaOhIMaAl_EC28q2rhoOUyT_JW_eJgjkCkeAGmOAoKv83m8ItV2sFzyDUpHzZOgJzqYWGKBGHHB-j7tbXo4dhWmqS0x5STixgn7pIUQF-je1dGQRF4K-hVwELoKsztza5LCC8XOPJe-1bYj2QHEhBWmVwbiEC0gfDuRIjoSRvHGhT1fL1xxyza4kjCrXu0YYklmurvxg", "reviews"=>[{"aspects"=>[{"rating"=>3, "type"=>"overall"}], "author_name"=>"Ralph Leftwich", "author_url"=>"https://plus.google.com/109523597684407562616", "language"=>"en", "rating"=>5, "text"=>"Great Music at The Loft. Danny Green and company provided a great night at the Loft in UCSD Price Center. We did not have dinner, but the coffee was great.", "time"=>1390063381}, {"aspects"=>[{"rating"=>0, "type"=>"overall"}], "author_name"=>"A Google User", "language"=>"en", "rating"=>1, "text"=>"Awful customer service. Waited 30 minutes for a grilled cheese panini and chili. Told the manager and he said &quot;that&#39;s the cost of fresh food.&quot; WTF?!", "time"=>1300433870}, {"aspects"=>[{"rating"=>2, "type"=>"overall"}], "author_name"=>"Justin Huang", "author_url"=>"https://plus.google.com/118126715366263719050", "language"=>"en", "rating"=>4, "text"=>"", "time"=>1331420203}, {"aspects"=>[{"rating"=>2, "type"=>"overall"}], "author_name"=>"Adam Best", "author_url"=>"https://plus.google.com/113696352457390445923", "language"=>"en", "rating"=>4, "text"=>"", "time"=>1308815827}, {"aspects"=>[{"rating"=>0, "type"=>"overall"}], "author_name"=>"A Google User", "language"=>"en", "rating"=>1, "text"=>"", "time"=>1310080154}], "types"=>["store", "cafe", "bar", "restaurant", "food", "establishment"], "url"=>"https://plus.google.com/103578164919888925696/about?hl=en-US", "user_ratings_total"=>8, "utc_offset"=>-420, "vicinity"=>"9500 Gilman Dr, La Jolla", "website"=>"http://www.zanzibarcafe.com/The-Loft.html"}, "status"=>"OK"}

     testOutput = JSON.parse(testOutput)
     assert testOutput["result"]["name"] == expectedOutput["result"]["name"]
     assert testOutput["result"]["adr_address"] == expectedOutput["result"]["adr_address"]
     assert testOutput["result"]["formatted_address"] == expectedOutput["result"]["formatted_address"]
     assert testOutput["result"]["formatted_phone_number"] == expectedOutput["result"]["formatted_phone_number"]
     assert testOutput["result"]["website"] == expectedOutput["result"]["website"]
     assert testOutput["result"]["vicinity"] == expectedOutput["result"]["vicinity"]
     assert testOutput["result"]["types"] == expectedOutput["result"]["types"]
     assert testOutput["result"]["url"] == expectedOutput["result"]["url"]
     assert testOutput["result"]["opening_hours"] == expectedOutput["result"]["opening_hours"]
     assert testOutput["result"]["address_components"] == expectedOutput["result"]["address_components"]
  end

  def test_invalid_request
    testOutput = Details.getDetails("foo")
    testOutput = JSON.parse(testOutput)
    expectedOutput = {"html_attributions"=>[],"status"=>"INVALID_REQUEST"}
    assert testOutput == expectedOutput, testOutput.to_s
  end

end
