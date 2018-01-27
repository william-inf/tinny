require 'tinny'

module Tinny::Calculators
  class HaversineResult
    EARTH_RADIUS_KILOMETERS = 6371
    EARTH_RADIUS_MILES = 3956
    EARTH_RADIUS_FEET = 5280

    attr_reader :haversine_distance

    def initialize(haversine_distance)
      @haversine_distance = haversine_distance
    end

    def to_kilometres
      @haversine_distance * EARTH_RADIUS_KILOMETERS
    end

    def to_metres
      to_kilometres * 1000
    end

    def to_miles
      @haversine_distance * EARTH_RADIUS_MILES
    end

    def to_feet
      to_miles * EARTH_RADIUS_FEET
    end
  end
end