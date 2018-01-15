module Tinny
  module Exception
    class InvalidHandlerException < StandardError
      def initialize(message = 'Please use a valid data handler. See docs.')
        super(message)
      end
    end
  end
end
