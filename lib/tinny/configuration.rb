require 'tinny/logger_helpers'

module Tinny
  class Configuration
    include LoggerHelpers

    attr_accessor :baud_rate, :device_mount_point

    def initialize
      @baud_rate = 500
      @device_mount_point = '/dev/ttyUSB0'
    end
  end
end