module Tinny
  module Exception
    class InvalidHandlerException < StandardError
      def initialize(message = 'Please use a valid data handler. See docs.')
        super(message)
      end
    end

    class MissingConfigException < StandardError
      def initialize(message = 'Missing/Invalid config block. See docs.')
        super(message)
      end
    end
  end
end
