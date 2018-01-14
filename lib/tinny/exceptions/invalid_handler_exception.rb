module Tinny
  module Exception
    class InvalidHandlerException < StandardError
      def initialize
        super('Please use a valid data handler. See docs for more info.')
      end
    end
  end
end
