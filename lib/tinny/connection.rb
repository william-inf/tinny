require 'tinny/logger_helpers'

module Tinny
  class Connection
    include LoggerHelpers

    attr_reader :name, :timer, :configured, :config

    def initialize(name)
      @name = name
      @configured = false
      @timer = Timers::Group.new
      @config = {}
    end

    def is_configured?
      @configured
    end

    def configure(**kwargs)
      @config = kwargs
      required_config.each do |val|
        raise "Missing config - #{val}" unless @config.has_key? val
      end

      @configured = true
    end

    def stream_data
      raise 'Run configure first to set up this connection' unless is_configured?
      log_info 'Beginning data stream ...'
      stream_data_impl
    end

    def required_config
      log_info 'Retrieving required config values for comparison'
      required_config_impl
    end

    def close
      log_info 'Closing connection ...'
      close_impl
    end

    protected def stream_data_impl
      raise 'Not here!'
    end

    protected def required_config_impl
      raise 'Not here!'
    end

    protected def close_impl
      raise 'Not here!'
    end
  end
end