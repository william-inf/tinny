require 'tinny'
require 'distance_utils'

module Tinny
  class CoordDistanceCalculator
    attr_reader :distance, :measurement

    def initialize(distance, measurement)
      @distance = distance
      @measurement = measurement
    end

    def completed_distance?(starting_lat_long, current_lat_long)
      current_distance = DistanceUtils.haversine(starting_lat_long, current_lat_long)
      current_distance > @distance
    end
  end
end