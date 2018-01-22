require 'tinny'
require 'tinny/data_handlers/temperature_handler'
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

      # We need to keep this alive for the actors that are initialised
      loop do
        log_debug 'We are running!'
        sleep 10
      end
    end
  end
end
