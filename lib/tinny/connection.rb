module Tinny
  class Connection

    attr_accessor :baud_rate, :device_mount_point

    def initialize
      @baud_rate = Tinny.configuration.baud_rate
      @device_mount_point = Tinny.configuration.device_mount_point
    end

  end
end