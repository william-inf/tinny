require 'tinny'
require 'tinny/logger_helpers'
require 'tinny/reactor'
require 'celluloid/current'

class TinnyService
  include LoggerHelpers, Celluloid

  attr_reader :options

  def initialize(**args)
    @options = {}
    @tasks_running = []
    handle_args(args)
  end

  def start_connection_loop(task_config)
    initialise_services
    start_workload(task_config)

    loop do
      sleep 10
    end
  end

  def start_workload(task_config)
    log_debug 'Starting connection loop, initialising all required tasks'
    @tasks_running << task_config.fetch(:name, 'Unknown')

    log_info "Kicking off '#{task_config.fetch(:name, 'Unknown')}' background task ..."
    @reactor.async.process(task_config)

  rescue Exception => ex
    whitelist = [SystemExit, NoMemoryError, SystemStackError, SignalException, ScriptError]

    if whitelist.find { |c| ex.is_a?(c) }
      log_error "Re-raising critical exception: #{ex.class}"
      raise ex
    end

    handle_rescuable_exception
  end

  private

  def initialise_services
    log_debug 'Initialising all mandatory services'
    @reactor = Tinny::Reactor.new
  end

  def handle_args(args)
    # Config @options in here
  end

  def handle_rescuable_exception

  end

end

# Example Code
# task_config = {
#     connection: 'serial_port_connection',
#     name: 'Temperature Sensor',
#     config: {
#         mount_point: '/dev/ttyACM5',
#         baud_rate: 9600,
#         data_bits: 8,
#         stop_bits: 1,
#         data_handler: Tinny::DataHandler::TemperatureHandler.new,
#         seconds_between_poll: 5
#     }
# }
#
# tinny = TinnyService.new
# tinny.start_connection_loop(task_config)
