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
      @data_map.fetch(:valid, false)
    end

    private def extract
      data = @gprmc_str.split(',')
      @data_map = {
          identifier: data[0],
          gmt_time: data[1],
          valid: data[2] == 'A' ? true : false,
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

# str = '$GPRMC,055441.000,A,3519.039624,S,14908.575991,E,0.27,192.89,270118,,,A*77'
# p Tinny::Calculators::GPRMCData.new(str, settings: true, abc: true).lat_long_ddmmmm
#
# [-35.28878382848341, 149.19249394121096]
# [-35.26797352499248, 149.1963563221924]