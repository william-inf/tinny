require 'tinny/data_handlers/handler'

# Example class reading DHT11 Sensor data passed from Arduino serial printing
module Tinny
  module DataHandler
    class TemperatureHandler < Tinny::DataHandler::Handler

      def initialize
        super(:temperature_handler)
      end

      def handle_impl(data_array)
        data_array.each do |data|
          if data.start_with? 'Temperature'
            Tinny.logger.info data
          end
        end
      end

    end
  end
end