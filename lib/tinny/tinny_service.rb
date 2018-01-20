require 'tinny'
require 'tinny/logger_helpers'
require 'tinny/reactor'
require 'celluloid/current'

module Tinny
  class TinnyService
    include LoggerHelpers, Celluloid

    attr_reader :options

    def initialize(**args)
      @options = {}
      @status = :pending
      @tasks_running = []
      handle_args(args)
      start_status_thread
    end

    def start_connection_loop(task_config)
      initialise_services
      start_workload(task_config)

      # We need to keep this alive for the actors that are initialised
      loop do
        sleep 10
      end
    end

    def start_workload(task_config)
      log_debug 'Starting connection loop, initialising all required tasks'
      @tasks_running << task_config.fetch(:name, 'Unknown')

      log_info "Kicking off '#{task_config.fetch(:name, 'Unknown')}' background task ..."
      set_status(:running)
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

    def start_status_thread
      set_status :starting
      log_info 'Starting heart beat thread...'
      Thread.new do
        log_info 'Status thread running'
        while true
          sleep(10)
          send_status
        end
      end
    end

    def set_status(status)
      @status = status
    end

    def send_status
      return if @options.fetch(:silence_status_thread, false)
      log_debug "Current status: #{@status}"
    end

    def handle_args(args)
      # Config @options in here
    end

    def handle_rescuable_exception
      # Implement me please!
      set_status :error
    end
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
# tinny = Tinny::TinnyService.new
# tinny.start_connection_loop(task_config)
