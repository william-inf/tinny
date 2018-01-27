require 'tinny/data_handlers/handler'
require 'tinny/calculators/distance_utils'
require 'tinny/calculators/gprmc_data'
require 'json'

# Example class reading MT3339 Sensor data passed from Arduino serial printing,
# performing some data transformation and persisting to InfluxDB for downstream
# processing.
module Tinny::DataHandler
  class GPSHandler < Tinny::DataHandler::Handler

    def initialize(handler_config)
      super(:dump_handler, handler_config)
      @starting_point = nil

      Firehose.configure do |config|
        config.host = @handler_config.fetch(:host, nil)
        config.username = @handler_config.fetch(:username, nil)
        config.password = @handler_config.fetch(:password, nil)
        config.database = @handler_config.fetch(:database, nil)
      end

      @data_svc = Firehose::InfluxDBService.new
    end

    def handle_impl(data_array)
      gprmc = deconstruct_gprmc_data(data_array[2])

      if gprmc.is_a? Tinny::Calculators::GPRMCData
        if @starting_point.nil?
          @starting_point = gprmc.lat_long_digital_degrees
        else
          distance = gprmc.compute_haversine(@starting_point)
          Tinny.logger.info "Streaming data: (Haversine) #{distance.to_metres}"

          @data_svc.with_tcp_client do |client|
            @data_svc.write_point(client, 'gps_location_data', gprmc.get_data_map)
          end
        end
      end
    end

    def deconstruct_gprmc_data(data_str)
      if data_str.start_with? '$GPRMC'
        gprmc = Tinny::Calculators::GPRMCData.new(data_str)
        return gprmc if gprmc.is_valid?
      end
      nil
    end
  end
end