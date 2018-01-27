require 'tinny/data_handlers/handler'
require 'tinny/calculators/distance_utils'
require 'tinny/calculators/gprmc_data'

# Example class reading DHT11 Sensor data passed from Arduino serial printing
module Tinny::DataHandler
  class GPSHandler < Tinny::DataHandler::Handler

    def initialize(handler_config)
      super(:dump_handler, handler_config)
      @starting_point = nil
    end

    def handle_impl(data_array)
      coords = deconstruct_gprmc_data(data_array[2])

      if coords.is_a? Array
        if @starting_point.nil?
          @starting_point = coords
        else
          distance = Tinny::Calculators::DistanceUtils.haversine(@starting_point, coords)
          Tinny.logger.info "Streaming data: #{distance.to_metres}"
        end
      end
    end

    def deconstruct_gprmc_data(data_str)
      if data_str.start_with? '$GPRMC'
        gprmc = Tinny::Calculators::GPRMCData.new(data_str)
        return gprmc.lat_long_digital_degrees if gprmc.is_valid?
      end

      nil
    end
  end
end