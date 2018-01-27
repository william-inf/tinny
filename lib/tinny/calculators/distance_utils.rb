require 'tinny'
require 'tinny/calculators/haversine_result'

module Tinny::Calculators
  # Haversine formula to calculate difference
  class DistanceUtils

    TO_RADIANS = Math::PI / 180

    def self.haversine(*coords)
      lat_a, lon_a, lat_b, lon_b = Array(coords).flatten
      distance_lat = lat_b - lat_a
      distance_lon = lon_b - lon_a

      haversine = (Math.sin(to_radians(distance_lat) / 2)) ** 2 +
          Math.cos(to_radians(lat_a)) * Math.cos((to_radians(lat_b))) *
          (Math.sin(to_radians(distance_lon) / 2)) ** 2

      HaversineResult.new(2 * Math.atan2(Math.sqrt(haversine), Math.sqrt(1 - haversine)))
    end

    def self.to_radians(n)
      n * TO_RADIANS
    end

    def self.convert_gps_at3339(*coords)
      lat, long = Array(coords).flatten

      lat_degree = (lat / 100).to_i
      lng_degree = (long / 100).to_i
      lat_mm_mmmm = lat % 100
      lng_mm_mmmmm = long % 100

      [(lat_degree + (lat_mm_mmmm / 60)).round(8), (lng_degree + (lng_mm_mmmmm / 60)).round(8)]
    end
  end
end
