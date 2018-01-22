require 'tinny'
require 'celluloid/current'

module Tinny
  class Task
    include Celluloid

    attr_reader :name, :task_config
    attr_accessor :handler

    def initialize(task_config)
      @name = task_config.fetch(:name, 'Unknown')
      @task_config = task_config
      @handler = nil
    end

    def get_data_handler_config
      @task_config[:data_handler]
    end

    def valid?
      # Do properly
      @task_config.is_a? Hash
    end

    def do_task
      @handler.stream_data
    end

  end
end
