require 'tinny/data_handlers/temperature_handler'
require 'tinny/connection'
require 'tinny/serial_port_connection'
require 'tinny/logger_helpers'
require 'celluloid/current'

module Tinny
  class Reactor
    include LoggerHelpers, Celluloid

    def initialize
      @connections = {}
      register_connections
    end

    def process(task_config)
      log_info "Beginning process for node using #{task_config.inspect}"
      handler = retrieve_handler(extract_name(task_config)).clone
      handler.configure(task_config[:config]) if handler
      handler.stream_data
    end

    def retrieve_handler(process_name)
      log_debug "Retrieving handler for #{process_name}"
      @connections.fetch(process_name, nil)
    end

    private

    def register_connections
      log_debug 'Registering connections for Tinny::Connection found in Object space'

      list = ObjectSpace.each_object(Class).select do |klass|
        klass < Tinny::Connection
      end

      list.each do |connection|
        connection_instance = connection.new

        log_debug "Found class #{connection_instance.name}. Adding to register hash"
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

# Example Code
serial_data = {
    connection: 'serial_port_connection',
    config: {
        mount_point: '/dev/ttyACM5',
        baud_rate: 9600,
        data_bits: 8,
        stop_bits: 1,
        data_handler: Tinny::DataHandler::TemperatureHandler.new,
        seconds_between_poll: 5
    }
}

Tinny::Reactor.new.async.process(serial_data)

loop do
  sleep 1
end