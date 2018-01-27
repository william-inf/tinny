module Tinny::DataHandler
  class Handler
    attr_reader :name, :handler_config

    def initialize(name, handler_config)
      @name = name
      @handler_config = handler_config
    end

    def handle(data_array)
      handle_impl(clean_data_array(data_array))
    end

    def handle_impl(data)
      raise 'Do not call base class!'
    end

    def clean_data_array(data_array)
      data_array.map { |val| val.chop! }
    end
  end
end
