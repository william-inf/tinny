require 'tinny'
require 'tinny/data_handlers/gps_handler'
require 'tinny/reactor'
require 'tinny/logger_helpers'

module Tinny
  class Control
    include LoggerHelpers
    def initialize(tasks_config)
      @tasks_config = tasks_config
    end

    def start
      tinny = Tinny::Reactor.new
      tinny.load_tasks(@tasks_config)
      tinny.tasks.each do |task|
        task.async.do_task
      end
    end
  end
end

# tasks_config = [{
#     connection: 'serial_port_connection',
#     name: 'GPS Sensor',
#     config: {
#         mount_point: '/dev/ttyS0',
#         baud_rate: 115200,
#         data_bits: 8,
#         stop_bits: 1,
#         data_handler: {
#             class: Tinny::DataHandler::GPSHandler,
#             config: {
#                 host: '127.0.0.1',
#                 username: 'admin',
#                 password: 'password',
#                 database: 'gps_data'
#             }
#         },
#         seconds_between_poll: 0.1
#     }
# }
# ]
#
# tinny = Tinny::Control.new(tasks_config)
# tinny.start
#
# loop do
#   sleep 10
# end
