require 'tinny/data_handlers/temperature_handler'
require 'tinny/connection'
require 'tinny/serial_port_connection'
require 'tinny/logger_helpers'
require 'tinny/task'

module Tinny
  class Reactor
    include LoggerHelpers
    attr_reader :tasks

    def initialize
      @connections = {}
      @tasks = []
      register_connections
    end

    def load_tasks(tasks_config)
      tasks_config.each do |task_config|
        task = Tinny::Task.new(task_config)
        (@tasks << task) if task.valid?
      end

      @tasks.each do |task|
        task.handler = get_handler(task.task_config)
      end
    end

    def get_handler(task_config)
      log_info "Beginning process for node using #{task_config.inspect}"
      handler = retrieve_connection(extract_name(task_config)).clone
      handler.configure(task_config[:config]) if handler
      handler
    end

    def retrieve_connection(process_name)
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
