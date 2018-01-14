require 'celluloid/current'
require 'tinny/data_handlers/temperature_handler'
require 'tinny/connection'
require 'tinny/serial_port_connection'

module Tinny
  class Reactor

    def initialize
      @connections = {}
      register_connections
    end

    def process(task_config)
      handler = retrieve_handler(extract_name(task_config))
      handler.process(packet) if handler
    end

    def retrieve_handler(process_name)
      @connections.fetch(process_name, nil)
    end

    private

    def register_connections
      list = ObjectSpace.each_object(Class).select do |klass|
        klass < Tinny::Connection
      end

      list.each do |connection|
        connection_instance = connection.new
        @connections[connection_instance.name] = connection_instance
      end
    end

    def extract_name(task_config)
      name = task_config.fetch(:connection, nil)
      raise 'No handler found!' unless name
      name.to_sym
    end

  end
end

serial_data = {
    connection: 'serial_port_connection',
    data: {
        mount_point: '/dev/ttyACM5',
        baud_rate: 9600,
        data_bits: 8,
        stop_bits: 1,
        data_handler: Tinny::DataHandler::TemperatureHandler.new
    }
}

Tinny::Reactor.new