module Tinny
  module DataHandler
    class Handler
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def handle(data_array)
        handle_impl(clean_data_array(data_array))
      end

      def handle_impl(data)
        raise 'Do not call base class!'
      end

      private def clean_data_array(data_array)
        data_array.map { |val| val.chop! }
      end

    end
  end
end