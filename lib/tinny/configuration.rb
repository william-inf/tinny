require 'tinny/logger_helpers'

module Tinny
  class Configuration

    attr_accessor :task_data

    def initialize
      @task_data = nil
    end
  end
end