require 'serialport'
require 'tinny/logger_helpers'
require 'tinny/connection'
require 'tinny/data_handlers/temperature_handler'
require 'tinny/exceptions/invalid_handler_exception'

module Tinny
  class SerialPortConnection < Tinny::Connection
    include LoggerHelpers

    attr_reader :mount_point, :baud_rate, :data_bits, :stop_bits, :parity

    def initialize
      super(:serial_port_connection)
    end

    def configure(mount_point, baud_rate, data_bits, stop_bits, parity = SerialPort::NONE)
      @mount_point = mount_point
      @baud_rate = baud_rate
      @data_bits = data_bits
      @stop_bits = stop_bits
      @parity = parity

      @configured = true
    end

    def stream_data(sec_pause, data_handler)
      raise 'Run configure first to set up this connection' unless @configured

      if data_handler.nil? || data_handler.class.superclass.name == Tinny::DataHandler::Handler
        raise Tinny::Exception::InvalidHandlerException.new
      end

      sp = SerialPort.new(@mount_point, @baud_rate, @data_bits, @stop_bits, @parity)

      loop do
        sleep(sec_pause)
        data_handler.handle(sp.readlines)
      end
    end

  end
end

# mount_point = '/dev/ttyACM5'
# baud_rate = 9600
# data_bits = 8
# stop_bits = 1
# sp = Tinny::SerialPortConnection.new(mount_point, baud_rate, data_bits, stop_bits).stream_data(5, Tinny::DataHandler::TemperatureHandler.new)


