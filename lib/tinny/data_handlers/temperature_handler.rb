require 'tinny/data_handlers/handler'
require 'firehose/influx_db_service'
require 'firehose'

# Example class reading DHT11 Sensor data passed from Arduino serial printing
module Tinny::DataHandler
  class TemperatureHandler < Tinny::DataHandler::Handler

    def initialize(handler_config)
      super(:temperature_handler, handler_config)

      # Do this properly in your own project!
      Firehose.configure do |config|
        config.host = @handler_config.fetch('host', nil)
        config.username = @handler_config.fetch(:username, nil)
        config.password = @handler_config.fetch(:password, nil)
        config.database = @handler_config.fetch(:database, nil)
      end

      @data_svc = Firehose::InfluxDBService.new
    end

    def handle_impl(data_array)
      data_array.each do |data|
        if data.start_with? 'Temperature'
          Tinny.logger.info "Streaming data: #{data}"

          @data_svc.with_tcp_client do |client|
            @data_svc.write_point(client, 'room_temp', { temperature: data.split('=').last.strip })
          end
        end
      end
    end
  end
end
