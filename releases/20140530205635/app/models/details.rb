require 'google_places'
require 'net/http'
require 'json'
require 'active_support'

class Details < ActiveRecord::Base
include DetailsHelper

    def self.getDetails(ref)
        url = DetailsHelper.build_url(ref)
        response = DetailsHelper.query_url(url)
    end
end
