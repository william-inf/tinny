require 'tinny'
require 'tinny/calculators/distance_utils'

module Tinny::Calculators

  attr_reader :gprmc_str, :data_map

  class GPRMCData
    def initialize(gprmc_str, **settings)
      @gprmc_str = gprmc_str
      @settings = settings
      @data_map = nil
    end

    def lat_long
      extract if @data_map.nil?
      [@data_map[:lat], @data_map[:lon]]
    end
    alias_method :lat_long_ddmmmm, :lat_long

    def lat_long_digital_degrees
      extract if @data_map.nil?
      DistanceUtils.convert_gps_at3339 [@data_map[:lat], @data_map[:lon]]
    end

    def is_valid?
      extract if @data_map.nil?
      res = @data_map.fetch(:valid, 'V')
      res == 'A'
    end

    def get_data_map
      extract if @data_map.nil?
      @data_map
    end

    def compute_haversine(starting_coords)
      return nil unless is_valid?
      Tinny::Calculators::DistanceUtils.haversine(starting_coords, lat_long_digital_degrees)
    end

    private def extract
      data = @gprmc_str.split(',')
      @data_map = {
          identifier: data[0],
          gmt_time: data[1],
          valid: data[2],
          lat: data[3].to_f,
          lat_dir: data[4],
          lon: data[5].to_f,
          lon_dir: data[6],
          speed_knots: data[7],
          tracking_angle: data[8],
          date: data[9]
      }
    end
  end
end
