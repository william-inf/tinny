require 'tinny/logger_helpers'

module Tinny
  class CanFrame
    include LoggerHelpers

    attr_reader :kind, :identifier, :length, :raw_data

    def initialize(kind, identifier, length, raw_data)
      @kind = kind
      @identifier = identifier.to_s(16)
      @length = length
      @raw_data = unpack_data(raw_data)
    end

    def unpack_data(data)
      log_debug "Unpacking data - #{data}"
      data.unpack('H*')
    end

  end

end