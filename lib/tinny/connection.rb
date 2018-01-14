module Tinny
  class Connection

    attr_accessor :name, :configured

    def initialize(name)
      @name = name
      @configured = false
    end

  end
end