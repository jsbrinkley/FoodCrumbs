
module JsonHelper

  # Returns the full title on a per-page basis.
  def self.JSONGetField(jsonString, stringField)

    #check if JSON is valid
    valid = JSONValidHelper.is_json?(jsonString)

    #if the Json is not valid, then we return false
    if(!valid)
      return false
    end

    #checks if we have it
    containsStatus = parsed.first.keys.should include(stringField)
    if(!containsStatus)
      return false
    end

    #get status of Google JSON. We know it is a json now
    parsed = JSON.parse(jsonString)

    #finally gets the field of interest
    status = parsed[stringField]
    return status
  end

  #throws an exception and returns false if it is not a json
  def @self.is_json?(jsonString)
    begin
      return false unless foo.is_a?(String)
      JSON.parse(jsonString).all?
    rescue JSON::ParserError
      false
    end
  end

  #given 2 json strings, it will hash the results together and return a single json
  def @self.hasher(json1, json2, field)
    arr1 = JSON.parse(json1)
    arr2 = JSON.parse(json2)
    mrg = []
    arr1.each do |el1|
      arr2.each do |el2|
        if el2[field] == el1[field]
          mrg.push(el1.merge(el2))
        end
      end
    end
    return mrg
  end

  #this is to get rid of all the garbage /u characters in our response
  def self.unicode_to_utf8(unicode_string)
    unicode_string.gsub(/\\u\w{4}/) do |s|
      str = s.sub(/\\u/, "").hex.to_s(2)
      if str.length < 8
        CGI.unescape(str.to_i(2).to_s(16).insert(0, "%"))
      else
        arr = str.reverse.scan(/\w{0,6}/).reverse.select{|a| a != ""}.map{|b| b.reverse}
        hex = lambda do |s|
          (arr.first == s ? "1" * arr.length + "0" * (8 - arr.length - s.length) + s : "10" + s).to_i(2).to_s(16).insert(0, "%")
        end
        CGI.unescape(arr.map(&hex).join)
      end
    end
  end




  def self.query_json(url)

    #key AIzaSyAAe8uFG4L8f_LYe-7etsNwdXraAUxIcPs

    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)

    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)

    response = http.request(request)

    puts("hello world\n")
    puts(response)

    foo = JSON.parse(response.body)
    puts(foo.to_json)

    #return RestaurantsAlongRoute.getRestaurant(setOfPoints)
   end
  end
