require 'tinny/connection'

RSpec.describe Tinny do
  it "has a version number" do
    expect(Tinny::VERSION).not_to be nil
  end

  describe '#configure' do
    before do
      Tinny.configure do |config|
        config.baud_rate = 10000
        config.device_mount_point = '/dev/ttyUSB1'
      end
    end

    it 'returns baud rate of 10000' do
      baud_rate = Tinny::Connection.new.baud_rate

      expect(baud_rate).to be_a Fixnum
      expect(baud_rate).to eq(10000)
    end

    it 'returns device mount point of /dev/ttyUSB1' do
      baud_rate = Tinny::Connection.new.device_mount_point

      expect(baud_rate).to be_a String
      expect(baud_rate).to eq('/dev/ttyUSB1')
    end
  end

  describe '.reset' do
    before :each do
      Tinny.configure do |config|
        config.baud_rate = 10000
      end
    end

    it 'resets configuration' do
      Tinny.reset
      config = Tinny.configuration
      expect(config.baud_rate).to eq(500)
    end
  end
end
