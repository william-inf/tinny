require 'tinny'
require 'tinny/data_handlers/temperature_handler'
require 'tinny/reactor'

module Tinny
  class Control
    def initialize(tasks_config)
      @tasks_config = tasks_config
    end

    def start
      tinny = Tinny::Reactor.new
      tinny.load_tasks(@tasks_config)
      tinny.tasks.each do |task|
        task.async.do_task
      end

      # We need to keep this alive for the actors that are initialised
      loop do
        sleep 10
      end
    end
  end
end

tasks_config = [{
    connection: 'serial_port_connection',
    name: 'Temperature Sensor',
    config: {
        mount_point: '/dev/ttyACM8',
        baud_rate: 9600,
        data_bits: 8,
        stop_bits: 1,
        data_handler: Tinny::DataHandler::TemperatureHandler.new,
        seconds_between_poll: 5
    }
},
{
    connection: 'serial_port_connection',
    name: 'Temperature Sensor',
    config: {
        mount_point: '/dev/ttyACM1',
        baud_rate: 9600,
        data_bits: 8,
        stop_bits: 1,
        data_handler: Tinny::DataHandler::TemperatureHandler.new,
        seconds_between_poll: 5
    }
}
]

tinny = Tinny::Control.new(tasks_config)
tinny.start
