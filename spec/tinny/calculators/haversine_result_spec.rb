require 'spec_helper'
require 'tinny/calculators/distance_utils'

module Tinny
  RSpec.describe Tinny::Calculators::DistanceUtils do
    describe "#convert_gps_at3339" do
      it "should convert to degrees decimal" do
        vals = Tinny::Calculators::DistanceUtils.convert_gps_at3339(3219.028548,15108.576290)
        expect(vals.class).to eq(Array)
        expect(vals[0]).to eq(32.31714247)
        expect(vals[1]).to eq(151.14293817)
      end
    end
  end
end