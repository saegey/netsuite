module NetSuite
  module Support
    module Requests

      def self.included(base)
        base.send(:extend, ClassMethods)
      end

      module ClassMethods

        def call(*args)
          new(*args).call
        end

      end

      def call
        @response = request
        build_response
      end

      private

      def request
        raise NotImplementedError, 'Please implement a #request method'
      end

      def build_response
        Response.new(:success => success?, header: response_header, :body => response_body, :response => @response)
      end

      def success?
        raise NotImplementedError, 'Please implement a #success? method'
      end

      def response_header
        nil
      end

      def response_body
        raise NotImplementedError, 'Please implement a #success? method'
      end

    end
  end
end
