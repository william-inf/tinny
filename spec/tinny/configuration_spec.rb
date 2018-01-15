require 'spec_helper'
require 'tinny/configuration'

module Tinny
  RSpec.describe Configuration do
    describe "#task_data" do
      it "default value is nil" do
        config = Configuration.new
        expect(config.task_data).to eq(nil)
      end
    end

    describe "#task_data=" do
      it "can set value" do
        config = Configuration.new
        config.task_data = '{}'
        expect(config.task_data).to eq('{}')
      end
    end
  end
end