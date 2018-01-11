require 'spec_helper'
require 'tinny/configuration'

module Tinny
  RSpec.describe Configuration do
    describe "#baud rate" do
      it "default value is 500" do
        config = Configuration.new
        expect(config.baud_rate).to eq(500)
      end
    end

    describe "#baud rate=" do
      it "can set value" do
        config = Configuration.new
        config.baud_rate = 10000
        expect(config.baud_rate).to eq(10000)
      end
    end

    describe "#device mount point" do
      it "default value is /dev/ttyUSB0" do
        config = Configuration.new
        expect(config.device_mount_point).to eq('/dev/ttyUSB0')
      end
    end

    describe "#baud rate=" do
      it "can set value" do
        config = Configuration.new
        config.device_mount_point = '/dev/ttyUSB1'
        expect(config.device_mount_point).to eq('/dev/ttyUSB1')
      end
    end
  end
end