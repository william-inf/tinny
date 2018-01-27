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
