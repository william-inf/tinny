require 'serialport'
require 'timers'
require 'tinny/logger_helpers'
require 'tinny/connection'
require 'tinny/data_handlers/temperature_handler'
require 'tinny/exceptions/exception'

module Tinny
  class SerialPortConnection < Tinny::Connection
    def initialize
      super(:serial_port_connection)
    end

    def stream_data_impl
      begin
        data_handler = create_data_handler
        if data_handler.nil? ||
            data_handler.class.superclass.name == Tinny::DataHandler::Handler
          raise Tinny::Exception::InvalidHandlerException.new
        end

        @sp = SerialPort.new(
            @config[:mount_point],
            @config[:baud_rate],
            @config[:data_bits],
            @config[:stop_bits],
            SerialPort::NONE
        )

        @timer.every(@config[:seconds_between_poll]) do
          value = @sp.readlines
          @sp.flush
          data_handler.handle(value)
        end

        loop { @timer.wait }
      end

    end

    def close_impl
      @sp.close if @sp
    end

    def required_config_impl
      [:mount_point,
       :baud_rate,
       :data_bits,
       :stop_bits,
       :data_handler,
       :seconds_between_poll]
    end

    def create_data_handler
      config = @config.fetch(:data_handler)
      data_handler_klazz = config[:class]
      data_handler_klazz.new(config[:config])
    end
  end
end
