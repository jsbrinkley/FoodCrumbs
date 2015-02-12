require 'test/unit'

class PlacesTest < Test::Unit::TestCase
   def test_places_default
     testOutput = Places.findPlaces(32.880578,-117.234832, 5000)
     expectedOutput = Places.findPlaces( 32.880578,-117.234832, 5000, "")
     testOutput = JSON.parse(testOutput)
     expectedOutput = JSON.parse(expectedOutput)
     for i in 1..testOutput.length
         assert testOutput["name"] == expectedOutput["name"]
     end
   end

   def test_places_no_results
     testOutput = Places.findPlaces(32.880578,-117.234832, 50)
     expectedOutput = {"html_attributions"=>[],"results"=>[],"status"=>"ZERO_RESULTS"}
     assert JSON.parse(testOutput) == expectedOutput, testOutput
   end

   def test_places_static_result
     testOutput = Places.findPlaces(32.880578,-117.234832, 150)
     expectedOutput = {"html_attributions"=>[],"results"=>[{"geometry"=>{"location"=>{"lat"=>32.87947,"lng"=>-117.236017}},"icon"=>"http=>//maps.gstatic.com/mapfiles/place_api/icons/cafe-71.png","id"=>"93ee0a8c60a10ce572275e8da588deff52a11a53","name"=>"Zanzibar Cafe At the Loft","opening_hours"=>{"open_now"=>false},"rating"=>3.6,"reference"=>"CoQBegAAAH5bGFdFfdjzL6tX34pEv4c8uGpz4ds7hxmahShPmblpnreCq2PiI0lanmqmj7uh9_0QQ3mBnE36tfyrJ0kOA_YNbEoAD7GgMUaiftsud9kd0GTHo1Jf2gmTVqILQrviTBgZM-ywWXPnPgFkkIxVA86zuD3LVWb4LRKl2vRpfKgvEhBONIyKCuVUZOdHe01j8LZKGhTFB1FPCtYEajppcdeqcmrN6cXWWw","types"=>["store","cafe","bar","restaurant","food","establishment"],"vicinity"=>"9500 Gilman Dr, La Jolla"},{"geometry"=>{"location"=>{"lat"=>32.879905,"lng"=>-117.236199}},"icon"=>"http=>//maps.gstatic.com/mapfiles/place_api/icons/restaurant-71.png","id"=>"acb694aef283dcab6c7d1580cbb4b5ba5faae808","name"=>"Bombay Coast","reference"=>"CnRuAAAA_CAXn1DAAns7qebSufSn3cJ25AH6Iagfn0RkhNORfNKa0iaERK-9S3a0Nndr_JJyIeghZkL3E0Y8QYY3yL7-D5ipBEiqdZjXRTSP8WU_B9ZVEWHL6cfT2kWDYIvAaV-cUlNYkwrSvYokTVWyn5uV7BIQO7gnSsMMZ3V0yLJBQ70eBRoUbZZpVJL0DQ6yECU9SKn1yL7HY6M","types"=>["restaurant","food","establishment"],"vicinity"=>"San Diego"}],"status"=>"OK"}
     testOutput = JSON.parse(testOutput)
     for i in 1..testOutput.length
         assert testOutput["name"] == expectedOutput["name"]
     end
   end
end
